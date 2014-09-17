#!/bin/bash

curl -o eve.db.bz2 "https://www.fuzzwork.co.uk/dump/hyperion-1.0-101505/eve.db.bz2"
bunzip2 eve.db.bz2
