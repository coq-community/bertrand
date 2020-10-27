# Bertrand

[![Travis][travis-shield]][travis-link]
[![Contributing][contributing-shield]][contributing-link]
[![Code of Conduct][conduct-shield]][conduct-link]
[![Zulip][zulip-shield]][zulip-link]
[![DOI][doi-shield]][doi-link]

[travis-shield]: https://travis-ci.com/coq-community/bertrand.svg?branch=master
[travis-link]: https://travis-ci.com/coq-community/bertrand/builds

[contributing-shield]: https://img.shields.io/badge/contributions-welcome-%23f7931e.svg
[contributing-link]: https://github.com/coq-community/manifesto/blob/master/CONTRIBUTING.md

[conduct-shield]: https://img.shields.io/badge/%E2%9D%A4-code%20of%20conduct-%23f15a24.svg
[conduct-link]: https://github.com/coq-community/manifesto/blob/master/CODE_OF_CONDUCT.md

[zulip-shield]: https://img.shields.io/badge/chat-on%20zulip-%23c1272d.svg
[zulip-link]: https://coq.zulipchat.com/#narrow/stream/237663-coq-community-devs.20.26.20users


[doi-shield]: https://zenodo.org/badge/DOI/10.1007/10930755_20.svg
[doi-link]: https://doi.org/10.1007/10930755_20

A proof of correctness of the algorithm for computing prime
numbers as described in "The Art of Computer Programming:
Fundamental Algorithms" by Knuth, pp. 147-149, and an
application using Bertrand's postulate.


## Meta

- Author(s):
  - Laurent Théry (initial)
- Coq-community maintainer(s):
  - Laurent Théry ([**@thery**](https://github.com/thery))
- License: [GNU Lesser General Public License v2.1 or later](LICENSE)
- Compatible Coq versions: Coq 8.8 or later
- Additional dependencies: none
- Coq namespace: `Bertrand`
- Related publication(s):
  - [Proving Pearl: Knuth's Algorithm for Prime Numbers](https://link.springer.com/chapter/10.1007%2F10930755_20) doi:[10.1007/10930755_20](https://doi.org/10.1007/10930755_20)

## Building and installation instructions

The easiest way to install the latest released version of Bertrand
is via [OPAM](https://opam.ocaml.org/doc/Install.html):

```shell
opam repo add coq-released https://coq.inria.fr/opam/released
opam install coq-bertrand
```

To instead build and install manually, do:

``` shell
git clone https://github.com/coq-community/bertrand.git
cd bertrand
make   # or make -j <number-of-cores-on-your-machine> 
make install
```
If you want to test the program verfied with [Why3](why3.lri.fr),
be sure to have [Why3](why3.lri.fr) and 
[Alt-Ergo](https://alt-ergo.ocamlpro.com/) installed. Once the `Bertrand`
library installed, do :

``` shell
make why_res
```
This has been tested with [Why3](why3.lri.fr) version `1.3.3` and
[Alt-Ergo](https://alt-ergo.ocamlpro.com/) version `2.3.3`

## Description

This project consists of:

- A proof of correctness of the algorithm as described in
  "The Art of Computer Programming: Fundamental Algorithms" by Knuth,
  pages 147-149.

- A proof of Bertrand's postulate: there always exists a prime between
  n and 2n for n greater than 2 (`Bertrand.v`).

- A little program that generates a partition of 1..2n in pairs (i,j)
  such that i+j is always prime (`run_partition.ml`).
  The proof of correctness of this program is a direct consequence of
  Bertrand's postulate (`Partition.v`). This nice application of Bertrand's
  postulate was suggested by Gérard Huet.

