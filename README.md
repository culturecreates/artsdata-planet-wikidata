Artsdata Planet Wikidata
================

This repo loads specific groups of entities from Wikidata that share common attributes such as membership in an Arts Organization (i.e. TAPA), or a specific type of organization (i.e. Orchestra).

Each SPARQL creates a dataset that is registered on the Artsdata Databus by running a Github workflow.  Each workflow can be set on a schedule. 

The SPARQL should only construct data relevant for reconciliation in Artsdata.  

All the standard Artsdata properties will get added to the Artsdata minted entity in the core graph after reconiliation.

Wikidata is an RDF source connected directly to Artsdata, so Artsdata core entities have properties annotated with the Wikidata URI used to derived the property.  The properties will be updated whenever the refresh routine is called on the core entity. For this reason the SPARQLs in this repo only need to load minimal data.
