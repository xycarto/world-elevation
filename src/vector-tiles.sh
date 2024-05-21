#!/bin/bash

echo "Deleting tile dir if exists..."
if [[ -d tiles/vector-tiles/countries ]]; then
    rm -rf tiles/vector-tiles/countries
fi

echo "Deleting tile dir if exists..."
if [[ -d tiles/vector-tiles/countries-admin ]]; then
    rm -rf tiles/vector-tiles/countries-admin
fi

echo "Deleting tile dir if exists..."
if [[ -d tiles/vector-tiles/place-points ]]; then
    rm -rf tiles/vector-tiles/place-points
fi

# echo "Deleting tile json if exists..."
# if [[ -f data/natural-earth/states-provinces-3857-explode.json ]]; then
#     rm data/natural-earth/states-provinces-3857-explode.json
# fi

# echo "Making single polys..."
# ogr2ogr -overwrite -explodecollections -makevalid -nlt POLYGON data/natural-earth/states-provinces-3857-explode.json data/natural-earth/states-provinces-3857.gpkg

echo "Making vector tiles..."
ogr2ogr -progress -makevalid -f MVT -dsco FORMAT=DIRECTORY -dsco COMPRESS=NO -dsco EXTENT=512 -dsco MAX_SIZE=5000000 -dsco SIMPLIFICATION=1 -dsco SIMPLIFICATION_MAX_ZOOM=3 tiles/vector-tiles/countries-admin data/natural-earth/states-provinces-3857.gpkg -dsco MAXZOOM=7

echo "Making vector tiles..."
ogr2ogr -progress -makevalid -f MVT -dsco FORMAT=DIRECTORY -dsco COMPRESS=NO -dsco SIMPLIFICATION=1 -dsco SIMPLIFICATION_MAX_ZOOM=5 tiles/vector-tiles/countries data/world-country-boundaries-3857.gpkg -dsco MAXZOOM=7

echo "Making vector tiles..."
ogr2ogr -progress -makevalid -f MVT -dsco FORMAT=DIRECTORY -dsco COMPRESS=NO tiles/vector-tiles/place-points data/world-country-points-3857.gpkg -dsco MAXZOOM=7

