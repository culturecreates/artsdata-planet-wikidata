Artsdata Planet Wikidata
================

This repo loads specific groups of entities from Wikidata that share common attributes such as membership in an Arts Organization (i.e. TAPA), or a specific type of organization (i.e. Orchestra).

Each SPARQL creates a dataset that is registered on the Artsdata Databus by running a Github workflow.  Each workflow can be set on a schedule. 

The SPARQL should only construct data relevant for reconciliation in Artsdata.  

All the standard Artsdata properties will get added to the Artsdata minted entity in the core graph after reconiliation when the entity is refreshed (synced).  

Wikidata is an RDF source connected directly to Artsdata.  The properties will be updated whenever the refresh routine is called on the Artsdata core entity. The Artsdata minted entites that are linked in the core graph to Wikidata (WikidataID -- sameAs --> ArtsdataID) get data directly from Wikidata, not the data feed graph. So all properties in the data feed graph are ingored when refreshing data. This is why the SPARQLs in this repo only need to load minimal data for initial linking.


Maintenance SPARQLs
-----------------
These SPARQLs help maintain accurate interlinking between Artsdata and Wikidata. Run the SPARQLs using the Wikidata Query tool. To use federated SPARQLs that look into both Wikidata and Artsdata, you must use the Wikidata query tool. Wikidata only allows federated SPARQLs out to white listed endpoints. Artsdata SPARQL endpoint is currenty on Wikidata's whitelist.

1. List all Wikidata P7627 values that have syntax errors
    * Fix in Wikidata by editing the P7627 values to have the right K-number syntax.
    * [Wikidata Query Service Link](https://query.wikidata.org/#SELECT%20%3Fitem%20%3FitemLabel%20%3FartsdataId%20WHERE%20%7B%0A%20%20%3Fitem%20wdt%3AP7627%20%3FartsdataId%20.%0A%20%20FILTER%28%21REGEX%28%3FartsdataId%2C%20%22%5EK%5B0-9%5D%2B-%5B0-9%5D%2B%24%22%29%29%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%2Cfr%22.%20%7D%0A%7D)
    

2. List all Wikidata entities missing an Artsdata P7627 value 
    * Fix using Open Refine to batch upload missing P7627 values to Wikidata.
    * [Wikidata Query Service Link](https://query.wikidata.org/#PREFIX%20schema%3A%20%3Chttp%3A%2F%2Fschema.org%2F%3E%0A%0APREFIX%20wdt%3A%20%3Chttp%3A%2F%2Fwww.wikidata.org%2Fprop%2Fdirect%2F%3E%0APREFIX%20wikibase%3A%20%3Chttp%3A%2F%2Fwikiba.se%2Fontology%23%3E%0APREFIX%20bd%3A%20%3Chttp%3A%2F%2Fwww.bigdata.com%2Frdf%23%3E%0ASELECT%20%3FwikidataItem%20%3FwikidataItemLabel%20%3FartsdataId%20WHERE%20%7B%0A%20%20SERVICE%20%3Chttps%3A%2F%2Fartsdata-trifid-production.herokuapp.com%2Fquery%3E%20%7B%0A%20%20%20%20SELECT%20%3FwikidataItem%20%3FartsdataId%20WHERE%20%7B%0A%20%20%20%20%20%20%3FartsdataEntity%20schema%3AsameAs%20%3FwikidataItem%20.%0A%20%20%20%20%20%20FILTER%28STRSTARTS%28STR%28%3FwikidataItem%29%2C%20%22http%3A%2F%2Fwww.wikidata.org%2Fentity%2F%22%29%29%0A%20%20%20%20%20%20FILTER%28STRSTARTS%28STR%28%3FartsdataEntity%29%2C%20%22http%3A%2F%2Fkg.artsdata.ca%2Fresource%2F%22%29%29%0A%20%20%20%20%20%20BIND%28STRAFTER%28STR%28%3FartsdataEntity%29%2C%20%22http%3A%2F%2Fkg.artsdata.ca%2Fresource%2F%22%29%20AS%20%3FartsdataId%29%0A%20%20%20%20%7D%0A%20%20%7D%0A%20%20FILTER%20NOT%20EXISTS%20%7B%20%3FwikidataItem%20wdt%3AP7627%20%3Fexisting%20.%20%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%2Cfr%22.%20%7D%0A%7D)
    

3. List all Artsdata entities missing a sameAs Wikidata entity
    *  Retrieve the Wikidata-interlinking graph: http://kg.artsdata.ca/culture-creates/artsdata-planet-wikidata/wikidata-interlinking.
    *  Load in the [batch reconciliation tool](https://kg.artsdata.ca/reconcile/batch?feedUrl=http%3A%2F%2Fkg.artsdata.ca%2Fculture-creates%2Fartsdata-planet-wikidata%2Fwikidata-interlinking&type=Agent&showAll=true) with the `Agent` type to review and add the missing sameAs links.
    * [Wikidata Query Service Link](https://query.wikidata.org/#PREFIX%20schema%3A%20%3Chttp%3A%2F%2Fschema.org%2F%3E%0APREFIX%20wdt%3A%20%3Chttp%3A%2F%2Fwww.wikidata.org%2Fprop%2Fdirect%2F%3E%0APREFIX%20wikibase%3A%20%3Chttp%3A%2F%2Fwikiba.se%2Fontology%23%3E%0APREFIX%20bd%3A%20%3Chttp%3A%2F%2Fwww.bigdata.com%2Frdf%23%3E%0A%0ASELECT%20%3FwikidataItem%20%3FwikidataItemLabel%20%3FartsdataId%20WHERE%20%7B%0A%20%20%3FwikidataItem%20wdt%3AP7627%20%3FartsdataId%20.%0A%20%20FILTER%20NOT%20EXISTS%20%7B%0A%20%20%20%20SERVICE%20%3Chttps%3A%2F%2Fartsdata-trifid-production.herokuapp.com%2Fquery%3E%20%7B%0A%20%20%20%20%20%20BIND%28IRI%28CONCAT%28%22http%3A%2F%2Fkg.artsdata.ca%2Fresource%2F%22%2C%20%3FartsdataId%29%29%20AS%20%3FartsdataEntity%29%0A%20%20%20%20%20%20%3FartsdataEntity%20schema%3AsameAs%20%3FwikidataItem%20.%0A%20%20%20%20%7D%0A%20%20%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%2Cfr%22.%20%7D%0A%7D) to the SPARQL used to populate the graph used by the Artsdata batch reconciliation tool.


These maintenance reports where created in issue:
https://github.com/culturecreates/artsdata-planet-wikidata/issues/11

