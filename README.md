# LOD Save the Queen

Group project for the Information Science and Cultural Heritage 2024/25 course.

The project maps the cultural impact of fashion designer and activist Vivienne Westwood using an ontology-based approach along with structured, linked data.

## Repository Structure

### csv
The `csv` directory contains the CSV files of our 10 items, one for each item,
described in natural language using a triple-like subject-predicate-object structure.

### csv2ttl
The `csv2ttl` directory contains the Python script that converts the CSV files
into Turtle format using RDFLib and the JSONs files used to map namespaces,
entities, and predicates from natural language to RDF.

To run the script, use the following command:

```bash
python csv2ttl/csv2ttl.py
```

The generated TTL files are saved in the [`ttl/csv2ttl`](https://github.com/metamuses/lod-save-the-queen/tree/main/ttl/csv2ttl) directory.

### html
The `html` directory contains the HTML, CSS and image files used to generate [the site of this project](https://metamuses.github.io/lod-save-the-queen), which is hosted on GitHub Pages.

### models
The `models` directory contains the theoretical and conceptual models of our
ontology.

### ttl
The `ttl` directory contains
- the Turtle file of the project global ontology, which is the result of the
  integration of the CSV files and some custom handcrafted elements
- the Turtle files generated from the `csv2ttl` script (see above)
- the Turtle file generated from the `xml2ttl` script (see below)

### xml
The `xml` directory contains the XML/TEI encoding of our source book "100 Days 
of Active Resistance" and the XSL stylesheet used to convert it into HTML format.

To run the conversion use the following command:

```bash
xsltproc xml/vivienne.xsl xml/vivienne.xml > xml2html/vivienne.html
```

### xml2ttl
The `xml2ttl` directory contains the Python script that converts the XML/TEI
encoding of our source book into Turtle format using RDFLib.

To run the script, use the following command:

```bash
python xml2ttl/xml2ttl.py
```

The generated file is saved in the [`ttl/xml2ttl`](https://github.com/metamuses/lod-save-the-queen/tree/main/ttl/xml2ttl) directory.

## Team members
- [Tommaso Barbato](https://github.com/epistrephein)
- [Nicol D'Amelio](https://github.com/nicoldamelio)
- [Martina Uccheddu](https://github.com/martinaucch)
