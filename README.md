# Correctness of Knuth&#39;s algorithm for prime numbers

[![Travis][travis-shield]][travis-link]
[![Contributing][contributing-shield]][contributing-link]
[![Code of Conduct][conduct-shield]][conduct-link]
[![Gitter][gitter-shield]][gitter-link]

[travis-shield]: https://travis-ci.com/coq-community/bertrand.svg?branch=master
[travis-link]: https://travis-ci.com/coq-community/bertrand/builds

[contributing-shield]: https://img.shields.io/badge/contributions-welcome-%23f7931e.svg
[contributing-link]: https://github.com/coq-community/manifesto/blob/master/CONTRIBUTING.md

[conduct-shield]: https://img.shields.io/badge/%E2%9D%A4-code%20of%20conduct-%23f15a24.svg
[conduct-link]: https://github.com/coq-community/manifesto/blob/master/CODE_OF_CONDUCT.md

[gitter-shield]: https://img.shields.io/badge/chat-on%20gitter-%23c1272d.svg
[gitter-link]: https://gitter.im/coq-community/Lobby

A proof of correctness of the algorithm as described in
"The Art of Computer Programming: Fundamental Algorithms"
by Knuth, pages 147-149.


## Meta

- Author(s):
  - Laurent Théry (initial)
- Coq-community maintainer(s):
  - Hugo Herbelin ([**@herbelin**](https://github.com/herbelin))
- License: [GNU Lesser General Public License v2.1](LICENSE)
- Compatible Coq versions: Coq 8.8 or greater (use releases for other Coq versions)
- Additional dependencies: none

## Building and installation instructions

The easiest way to install the latest released version is via
[OPAM](https://opam.ocaml.org/doc/Install.html):

```shell
opam repo add coq-released https://coq.inria.fr/opam/released
opam install coq-bertrand
```

To instead build and install manually, do:

``` shell
git clone https://github.com/coq-community/bertrand
cd bertrand
make   # or make -j <number-of-cores-on-your-machine>
make install
```

After installation, the included modules are available under
the `Bertrand` namespace.

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

