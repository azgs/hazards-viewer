# Natural Hazards in Arizona

A map of natural hazards in Arizona. Built by the [AZGS](http://azgs.az.gov) and [ADEM]() with funding from [FEMA](http://www.fema.gov). The initial scope is to show information about [earth fissures](http://www.azgs.az.gov/EFC.shtml), geologically "active" faults, [earthquakes](http://azgs.az.gov/az-shakes/), [flood risks](http://www.azgs.az.gov/hazards_floods.shtml), and wildfire risk.

The map itself can be viewed here: http://data.azgs.az.gov/hazard-viewer/

## Development Setup

Prerequisites: Nodejs

The following steps run an install script which compiles the javascript from coffeescript, the html from jade and the css from less. It was created for a Linux/Mac enviroment but see steps below to get the application running in Windows, or you can create your own watchers in your IDE. In the future an equivalent `install.sh` needs to be created for Windows or a cross-platform install script should to be written (using shelljs?). 

In a **Linux/Mac** environment:

```
$ npm install
$ node server.js
```

In a **Windows** environment:

- Modify `package.json` by removing `./` before `install.sh`:
```
"install": "install.sh"
```
- In a Windows terminal:
```
> npm install
```
- In the new `scripts` directory move everything from `scripts/src` to `scripts`
- Move `scripts/server.js` to the hazards viewer root, `hazards-viewer`
```
> node server.js
```

Page is served out at `http://localhost:3001/`

In **[Cloud9](https://c9.io/) Linux** environment:

After above steps make sure to change the port to 8080 in `server.js`. That is `app.listen(3001);` should be changed to `app.listen(8080);`Page is accessed at your Cloud9 web server page though make sure to use 'http' instead of 'https'.

## About these data

### Earth Fissures

Earth fissures are open surface fractures that may be as much as a mile in length, up to 15 ft wide, and 10s of feet deep.

__Update Frequency:__ These data are updated infrequently. Updates require changes to the AZGS Hazards database, and should be accompanied by changes in the [AZGS document repository](http://repository.azgs.az.gov/facets/results/taxonomy%3A228), the [primary Earth Fissure site](http://www.azgs.az.gov/EFC.shtml), and the [dedicated Earth Fissure map](http://services.azgs.az.gov/OnlineMaps/fissures.html)

### Active Faults

Faults that are known to have been active within the last 2.5 million years (Quaternary period), and thus have some chance that they could generate a large earthquake.

__Update Frequency:__ This dataset is updated infrequently. Updates require changes to the AZGS Hazards database, and should be accompanied by changes to [Arizona's NGDS Active Faults data service](http://services.azgs.az.gov/ArcGIS/rest/services/aasggeothermal/AZActiveFaults/MapServer)

### Earthquake Epicenters

The earthquakes displayed are from the AZGS Earthquake Catalog, and are the minimum number of earthquakes that have occurred in the historical period dating to about 1850.

__Update Frequency:__ This dataset is regularly updated, and new/changed data are automatically displayed on the map.

### Flood Potential

Areas with High and Medium flooding potential as represented by the 100- and 500- flood zones determined by the Federal Emergency Management Agency (FEMA) digital flood insurance rate maps (DFIRM) database, dated May 2010.

__Update Frequency:__ This dataset was created in 2010 and will be updated infrequently. Any updates will require changes to the AZGS Hazards database.

### Fire Risk

Relative risks of wildfire based on values at risk (i.e. development, infrastructure, etc.), the likelihood of an acre to burn, the expected final fire size based on fuels conditions and potential fire behavior and the difficulty or expense of suppression.

__Update Frequency:__ This dataset is not maintained by the AZGS and will be updated infrequently. Updates may involve:

- Reclassifying a raster for simple categorization of fire risk
- Updating the [backend for the WCS service](http://data.usgin.org/arizona/ows?service=wcs&version=1.0.0&request=GetCapabilities)
- Rebuilding .png tiles and replacing the existing set (http://{s}.tiles.usgin.org/fire-risk-index/{z}/{x}/{y}.png)
