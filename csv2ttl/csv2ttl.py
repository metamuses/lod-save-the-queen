# CSV2TTL
# Convert CSV files to Turtle (TTL) format for RDF representation

from pathlib import Path
import json
import csv
from rdflib import Graph, Namespace, URIRef, Literal

# Resolve base and CSV/TTL directories
BASE_DIR = Path(__file__).resolve().parent
ROOT_DIR = BASE_DIR.parent
CSV_DIR = ROOT_DIR / "csv"
TTL_DIR = ROOT_DIR / "ttl" / "csv2ttl"

# Define the base URI for the RDF graph
BASE_URI = "https://github.com/metamuses/lod-save-the-queen/"

# Load namespaces, predicates, and entities from JSON files
with open(BASE_DIR.joinpath("namespaces.json"), "r", encoding="utf-8") as ns_file:
    NAMESPACES = {k: Namespace(v) for k, v in json.load(ns_file).items()}

with open(BASE_DIR.joinpath("predicates.json"), "r", encoding="utf-8") as pred_file:
    PREDICATES = json.load(pred_file)

ALWAYS_LITERAL_PREDICATES = ["dc:title"]

with open(BASE_DIR.joinpath("entities.json"), "r", encoding="utf-8") as ent_file:
    ENTITIES = json.load(ent_file)

# Collect all local entities from CSV files first
CSV_ENTITIES = {}
for filepath in CSV_DIR.glob("*.csv"):
    with open(filepath, "r", encoding="utf-8") as csvfile:
        subject = next(csv.DictReader(csvfile)).get("subject")
        CSV_ENTITIES[subject] = filepath.stem

CSV_ENTITIES_PREFIX = "item/"

# Iterate over all CSV files in the CSV directory
for filepath in CSV_DIR.glob("*.csv"):
    # Read the CSV file
    # csv_path = CSV_DIR.joinpath(filename)
    with open(filepath, "r", encoding="utf-8") as csvfile:
        reader = csv.DictReader(csvfile)

        # Create a new RDF graph
        g = Graph()

        # Use the file name as the subject URI
        name = filepath.stem
        subj = URIRef(BASE_URI + CSV_ENTITIES_PREFIX + name)

        # Process each row in the CSV
        for row in reader:
            # Extract the namespace and predicate from mapping
            full_predicate = PREDICATES[row["predicate"]]
            namespace_str, predicate_str = full_predicate.split(":")
            namespace = NAMESPACES[namespace_str]
            # Bind the namespace to the graph
            g.bind(namespace_str, namespace)
            # Create the predicate URI
            pred = namespace[predicate_str]

            # Determine the object based on whether it's csv entity, prefixed URI, or literal
            if full_predicate in ALWAYS_LITERAL_PREDICATES:
                # If the predicate is for a literal, always create a Literal object
                obj = Literal(row["object"])
            elif row["object"] in CSV_ENTITIES:
                # If it's a csv entity, create a URIRef from base for it
                obj = URIRef(BASE_URI + CSV_ENTITIES_PREFIX + CSV_ENTITIES[row["object"]])
            elif row["object"] in ENTITIES:
                # Check if the entity is a prefixed URI or a full URI
                entity = ENTITIES[row["object"]]
                if ":" not in entity:
                    # If it's a prefixed URI, use the base URI to create the object
                    obj = URIRef(BASE_URI + entity)
                else:
                    # If it's a full URI, split it into namespace and entity
                    namespace_str, entity_str = entity.split(":")
                    namespace = NAMESPACES[namespace_str]
                    # Bind the namespace to the graph
                    g.bind(namespace_str, namespace)
                    # Create the object URI
                    obj = namespace[entity_str]
            else:
                # If it's a literal, create a Literal object
                obj = Literal(row["object"])

            # Add the triple to the graph
            g.add((subj, pred, obj))

    # Serialize the graph to Turtle format
    TTL_DIR.mkdir(exist_ok=True)
    ttl_path = TTL_DIR / f"{name}.ttl"
    g.serialize(destination=ttl_path, format="turtle", base=BASE_URI)
