<!---
This file was generated from `meta.yml`, please do not edit manually.
Follow the instructions on https://github.com/coq-community/templates to regenerate.
--->
# Bertrand

[![Docker CI][docker-action-shield]][docker-action-link]
[![Contributing][contributing-shield]][contributing-link]
[![Code of Conduct][conduct-shield]][conduct-link]
[![Zulip][zulip-shield]][zulip-link]
[![DOI][doi-shield]][doi-link]

[docker-action-shield]: https://github.com/coq-community/bertrand/workflows/Docker%20CI/badge.svg?branch=master
[docker-action-link]: https://github.com/coq-community/bertrand/actions?query=workflow:"Docker%20CI"

[contributing-shield]: https://img.shields.io/badge/contributions-welcome-%23f7931e.svg
[contributing-link]: https://github.com/coq-community/manifesto/blob/master/CONTRIBUTING.md

[conduct-shield]: https://img.shields.io/badge/%E2%9D%A4-code%20of%20conduct-%23f15a24.svg
[conduct-link]: https://github.com/coq-community/manifesto/blob/master/CODE_OF_CONDUCT.md

[zulip-shield]: https://img.shields.io/badge/chat-on%20zulip-%23c1272d.svg
[zulip-link]: https://coq.zulipchat.com/#narrow/stream/237663-coq-community-devs.20.26.20users


[doi-shield]: https://zenodo.org/badge/DOI/10.1007/10930755_20.svg
[doi-link]: https://doi.org/10.1007/10930755_20

A Coq proof of Bertrand's postulate, which says that there always
exists a prime between n and 2n for n greater than 2. Includes
an application of the postulate to compute partitions.

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


## Contents

This project consists of:

- A Coq proof of Bertrand's postulate: there always exists a prime between
  n and 2n for n greater than 2 (`Bertrand.v`).
- A little program in OCaml, based on code extracted from Coq,
  that generates a partition of 1..2n in pairs (i,j) such that i+j
  is always prime (`run_partition.ml`). The proof of correctness
  of this program is a direct consequence of Bertrand's postulate (`Partition.v`).
  This nice application of Bertrand's postulate was suggested by Gérard Huet.
- A proof of correctness of an implementation of the algorithm for computing primes
  described in "The Art of Computer Programming: Fundamental Algorithms" by Knuth,
  pages 147-149. The proof uses the [Why3 tool](http://why3.lri.fr) to generate
  verification conditions for the WhyML program that implements the algorithm.
  These verification conditions can then be discharged by Coq and the
  [Alt-Ergo](https://alt-ergo.ocamlpro.com) prover.

## Extracting and running the OCaml partition program

To extract code and obtain the program, run
```shell
make run_partition.ml
```

Next, open an OCaml toplevel (e.g., `ocaml`) and do
```ocaml
#use "run_partition.ml";;
```

To get a partition from 1...30:
```ocaml
let part30 = part 15;;
```

## Replaying the WhyML program correctness proof

To replay the proof of correctness for the WhyML program for computing primes,
first make sure the following packages are installed (in addition to Coq 8.13.2
and the proof of Bertrand's postulate):

- [Alt-Ergo 2.4.1](https://alt-ergo.ocamlpro.com)
- [Why3 1.4.1](http://why3.lri.fr) and its Coq library

These packages can be installed via OPAM using the following command:
```
opam install alt-ergo.2.4.1 why3.1.4.1 why3-coq.1.4.1
```
Then, the proof can be replayed by running
```
make why
```

