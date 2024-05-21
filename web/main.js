import './style.css';
import {Map, View} from 'ol';
import TileLayer from 'ol/layer/Tile';
import XYZ from 'ol/source/XYZ.js';import MVT from 'ol/format/MVT';
import VectorTileLayer from 'ol/layer/VectorTile';
import VectorTileSource from 'ol/source/VectorTile';
import {fromLonLat} from 'ol/proj';
import Fill from 'ol/style/Fill.js';
import Stroke from 'ol/style/Stroke.js';
import Style from 'ol/style/Style.js';
import { apply } from 'ol-mapbox-style';
import {stylefunction} from 'ol-mapbox-style';


const xyzUrl = "http://127.0.0.1:8080/world-elevation/v1/world-elevation/{z}/{x}/{y}.png"

const mono = new TileLayer({
  title: 'basemap',
  crossOrigin: 'anonymous',
  source: new XYZ({
    url: xyzUrl,
    wrapX: true,
  })
});

// Vector Tiles
// const vtSyle = new Style({
//   stroke: new Stroke({
//     color: '#222222',
//     width: 1,
//   }),
// });

const vtAdmin = new VectorTileSource({
  format: new MVT(),
  tileSize: 512,
  maxZoom: 7,
  overlaps: false,
  url: 'http://127.0.0.1:8080/vector-tiles/countries-admin/{z}/{x}/{y}.pbf'
})

const vtCountries= new VectorTileSource({
  format: new MVT(),
  maxZoom: 7,
  overlaps: false,
  url: 'http://127.0.0.1:8080/vector-tiles/countries/{z}/{x}/{y}.pbf'
})

const vtCountriesPoints = new VectorTileSource({
  format: new MVT(),
  maxZoom: 7,
  overlaps: false,
  url: 'http://127.0.0.1:8080/vector-tiles/place-points/{z}/{x}/{y}.pbf'
})

const vectorAdmin = new VectorTileLayer({
  title: 'Tile Grid',
  declutter: false,
  visible: true,
  source:  vtAdmin,
  minZoom: 5,
  style: {
    'stroke-width': 0.35,
    'stroke-color': '#aaaaaa',
  },
});

const vectorCountries = new VectorTileLayer({
  title: 'Tile Grid',
  declutter: false,
  visible: true,
  source:  vtCountries,
  renderMode: 'vector'
});

const vectorCountriesPoints = new VectorTileLayer({
  declutter: true,
  visible: true,
  source: vtCountriesPoints,
  renderMode: 'vector',
  useInterimTilesOnError: false
});

// Draw map
const map = new Map ({
  layers: [mono, vectorCountriesPoints, vectorCountries, vectorAdmin],
  target: 'map',
  view: new View({
    center: [0,0],
    zoom: 0,
    constrainResolution: true,
    maxZoom: 7
  })
});

// Get JSON for vector tile styles and apply styling to vector tiles
fetch('styles/vt-style.json').then(function(response) {
  response.json().then(function(glStyle) {
    stylefunction(vectorCountriesPoints, glStyle, 'place-points-country');
  });
});

fetch('styles/vt-style.json').then(function(response) {
  response.json().then(function(glStyle) {
    stylefunction(vectorCountries, glStyle, 'world_styles');
  });
});

