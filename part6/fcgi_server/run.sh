#!/bin/bash
service nginx start
nginx -s reload
spawn-fcgi -p 81 a.out

while true; do
        wait
done