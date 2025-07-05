# CSV2TTL
# Convert XML/TEI file to Turtle (TTL) collecting RDF entities

from pathlib import Path
from rdflib.namespace import DCTERMS, FOAF, OWL, RDF, RDFS, SDO
from rdflib import URIRef, Literal, Graph
from lxml import etree

BASE_DIR = Path(__file__).resolve().parent
ROOT_DIR = BASE_DIR.parent
XML_DIR = ROOT_DIR / "xml"
TTL_DIR = ROOT_DIR / "ttl" / "xml2ttl"

# Load TEI file
tree = etree.parse(XML_DIR / "vivienne.xml")
ns = {"tei": "http://www.tei-c.org/ns/1.0"}

# Create RDF graph
g = Graph()

# Namespaces
BASE_URI = "https://github.com/metamuses/lod-save-the-queen/"
TEI_PREFIX = "tei/"

g.bind("dcterms", DCTERMS)
g.bind("foaf", FOAF)
g.bind("owl", OWL)
g.bind("rdfs", RDFS)
g.bind("schema", SDO)

# ==== main encoding entity ====
# Build main entity URI
encoding_name = "encoding"
encoding_uri = URIRef(BASE_URI + TEI_PREFIX + encoding_name)
g.add((encoding_uri, RDF.type, DCTERMS.BibliographicResource))

# Extract title
title = tree.find(".//tei:titleStmt/tei:title", namespaces=ns)
g.add((encoding_uri, DCTERMS.title, Literal(title.text.strip())))

# Extract date
pub_date = tree.find(".//tei:publicationStmt/tei:date", namespaces=ns)
g.add((encoding_uri, DCTERMS.issued, Literal(pub_date.attrib["when"])))

# Extract contributors
for pers in tree.findall(".//tei:respStmt/tei:persName", namespaces=ns):
    full_name = " ".join(" ".join(pers.itertext()).split())
    g.add((encoding_uri, DCTERMS.contributor, Literal(full_name)))
# ==== /main encoding entity ====

# ==== main bibliographic entity ====
# Build bibliographic entity URI
book_name = "book"
book_uri = URIRef(BASE_URI + TEI_PREFIX + book_name)
g.add((book_uri, RDF.type, DCTERMS.BibliographicResource))

# Link main encoding entity to bibliographic entity
g.add((encoding_uri, DCTERMS.source, book_uri))

# Find element in the TEI tree
book_path = ".//tei:sourceDesc/tei:bibl"
book_el = tree.find(book_path, namespaces=ns)

# Extract sameAs
book_sameas = book_el.attrib.get("sameAs")
g.add((book_uri, OWL.sameAs, URIRef(book_sameas.strip())))

# Extract title
book_title = book_el.find(".//tei:title", namespaces=ns)
g.add((book_uri, DCTERMS.title, Literal(book_title.text.strip())))

# Extract author
book_author = book_el.find(".//tei:author", namespaces=ns)
g.add((book_uri, DCTERMS.creator, Literal(book_author.text.strip())))

# Extract publisher
book_publisher = book_el.find(".//tei:publisher", namespaces=ns)
g.add((book_uri, DCTERMS.publisher, Literal(book_publisher.text.strip())))

# Extract publication date
book_date = book_el.find(".//tei:date", namespaces=ns)
g.add((book_uri, DCTERMS.issued, Literal(book_date.attrib["when"])))

# Extract publication place
book_place = book_el.find(".//tei:pubPlace", namespaces=ns)
g.add((book_uri, DCTERMS.spatial, Literal(book_place.text.strip())))

# Extract identifier
book_idno = book_el.find(".//tei:idno", namespaces=ns)
g.add((book_uri, DCTERMS.identifier, Literal(book_idno.text.strip())))
# ==== /main bibliographic entity ====

# ==== inferred bibliographic entities ====
# Create mapping for later use
bibl_map = {}  # key: xml:id, value: URI

# Find element in the TEI tree
bibl_path = ".//tei:listBibl[@type='inferred-bibliographic-refences']/tei:bibl"

for bibl in tree.findall(bibl_path, namespaces=ns):
    # Build bibliographic entity URI
    bibl_id = bibl.attrib.get("{http://www.w3.org/XML/1998/namespace}id")
    bibl_uri = URIRef(BASE_URI + TEI_PREFIX + bibl_id)
    bibl_map[bibl_id] = bibl_uri
    g.add((bibl_uri, RDF.type, DCTERMS.BibliographicResource))

    # Extract title
    bibl_title = bibl.find(".//tei:title", namespaces=ns)
    g.add((bibl_uri, DCTERMS.title, Literal(bibl_title.text.strip())))

    # Extract author
    bibl_author = bibl.find(".//tei:author", namespaces=ns)
    author_name = " ".join(bibl_author.itertext()).strip()
    g.add((bibl_uri, DCTERMS.creator, Literal(author_name)))
# ==== /inferred bibliographic entities ====

# ==== characters entities ====
# Create mapping for characters: label, path, is_person, name_path
chars_mapping = [
    (
        "cited-person",
        ".//tei:listPerson[@type='cited-person']/tei:person",
        True,
        ".//tei:persName"
    ),
    (
        "cited-fictional-character",
        ".//tei:list[@type='cited-fictional-character']/tei:item",
        False,
        ".//tei:name"
    ),
    (
        "cited-mythological-figure",
        ".//tei:list[@type='cited-mythological-figure']/tei:item",
        False,
        ".//tei:name"
    )
]

for label, path, is_person, name_path in chars_mapping:
    for el in tree.findall(path, namespaces=ns):
        # Find element attributes
        xml_id = el.attrib.get("{http://www.w3.org/XML/1998/namespace}id")
        name_el = el.find(name_path, namespaces=ns)
        same_as = el.attrib.get("sameAs")
        ref = el.attrib.get("ref")

        # Extract name and role
        name = " ".join(" ".join(name_el.itertext()).split())
        role = name_el.attrib.get("role") or name_el.attrib.get("type")

        # Build character URI
        uri = URIRef(BASE_URI + TEI_PREFIX + xml_id)

        # Add character to the graph
        g.add((uri, RDF.type, SDO.Character))
        g.add((uri, RDFS.label, Literal(name)))

        # Add type based on is_person flag
        if is_person:
            g.add((uri, RDF.type, FOAF.Person))

        # Add role if present
        if role:
            g.add((uri, DCTERMS.subject, Literal(role)))

        # Add sameAs if present
        if same_as:
            g.add((uri, OWL.sameAs, URIRef(same_as)))

        # Add ref if present
        if ref:
            # If the ref points to a known bibliographic item, link it
            ref_id = ref.strip().lstrip("#")
            if ref_id in bibl_map:
                g.add((uri, DCTERMS.references, bibl_map[ref_id]))
            else:
                # Otherwise, link the ref as URL
                g.add((uri, SDO.url, URIRef(ref)))

        # Link entity as reference in the encoding entity
        g.add((encoding_uri, DCTERMS.references, uri))
# ==== /characters entities ====

# Serialize graph to Turtle format
TTL_DIR.mkdir(exist_ok=True)
ttl_path = TTL_DIR / "xml2rdf.ttl"
g.serialize(destination=ttl_path, format="turtle", base=BASE_URI)
