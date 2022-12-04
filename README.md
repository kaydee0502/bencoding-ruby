# bencoding-ruby
A simple ruby bencoding encoder and decoder


## Introduction
Bencode (pronounced "Bee-Encode") is the encoding used by the peer-to-peer file sharing system BitTorrent for storing and transmitting loosely structured data.

It supports four different types of values:

- byte strings,
- integers,
- lists, and
- dictionaries (associative arrays).
Bencoding is most commonly used in .torrent files. These metadata files are simply bencoded dictionaries.

While less efficient than a pure binary encoding, bencoding is simple and (because numbers are encoded in decimal notation) is unaffected by endianness, which is important for a cross platform application like BitTorrent. It is also fairly flexible, as long as applications ignore unexpected dictionary keys, so that new ones can be added without creating incompatibilities.

## Encoding algorithm
Bencode uses ASCII characters as delimiters and digits.

- An integer is encoded as ie. Note that negative values are allowed by prefixing the number with a minus sign, but leading zeros are not allowed (although the number zero is still represented as "0"). The number 42 would thus be encoded as "i42e".

- A byte string (a sequence of bytes, not necessarily characters) is encoded as {length}:{contents}. (This is similar to netstrings, but without the final comma.) The length is encoded in base 10, like integers, but must be non-negative (zero is allowed); the contents are just the bytes that make up the string. The string "spam" would be encoded as "4:spam". The specification does not deal with encoding of characters outside the ASCII set; to mitigate this, some BitTorrent applications explicitly communicate the encoding (most commonly UTF-8) in various non-standard ways.

- A list of values is encoded as l{contents}e . The contents consist of the bencoded elements of the list, in order, concatenated. A list consisting of the string "spam" and the number 42 would be encoded as: "l4:spami42ee"; note the absence of separators between elements.

- A dictionary is encoded as d{contents}e. The elements of the dictionary are again encoded and concatenated, in such a way that each value immediately follows the key associated with it. All keys must be byte strings and must appear in lexicographical order. A dictionary that associates the values 42 and "spam" with the keys "foo" and "bar", respectively, would be encoded as follows: "d3:bar4:spam3:fooi42ee". (This might be easier to read by inserting some spaces: "d 3:bar 4:spam 3:foo i42e e".)
There are no restrictions on what kind of values may be stored in lists and dictionaries; they may (and usually do) contain other lists and dictionaries. This allows for arbitrarily complex data structures to be encoded; it's one of the advantages of using bencoding.

Source: [https://code.google.com/archive/p/bencode-net/wikis/BEncode.wiki](https://code.google.com/archive/p/bencode-net/wikis/BEncode.wiki)

```ruby

 example = "d1:ai123e3:badd1:c6:deepak2:aed1:yi69e1:xli23e6:kaydeed1:v1:ueeeee"
 example_hash = {
       "a":123,
         "bad": {
          "c": "deepak",
          "ae": {
            "y": 69,
            "x": [23, "kaydee", {"v": "u"}]
          }
        }
      }
 ```
