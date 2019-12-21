# pyzor-server
Dockerized version of Pyzor

## What is Pyzor?
https://pyzor.readthedocs.io/en/latest/introduction.html

## Why this license?
Inherited from Pyzor

## Why this repo?
I'm trying to start a Pyzor server for custom antispam implementation. Docker is very useful to start single services

## Requirements
A Redis instance (i'll implement it on a docker-compose file)

## Usage
coming up...

## Digest
To generate a digest, the 2.0 version of the Pyzor protocol:

 * Discards all message headers.
 * If the message is greater than 4 lines in length:
 
  * Discards the first 20% of the message.
  * Uses the next 3 lines.
  * Discards the next 40% of the message.
  * Uses the next 3 lines.
  * Discards the remainder of the message.
  
 * Removes any 'words' (sequences of characters separated by whitespace) that are 10 or more characters long.
 * Removes anything that looks like an email address (X@Y).
 * Removes anything that looks like a URL.
 * Removes anything that looks like HTML tags.
 * Removes any whitespace.
 * Discards any lines that are fewer than 8 characters in length.
 
