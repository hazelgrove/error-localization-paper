# Supplement Material

This zip contains the supplemental materials for *Bidirectional Type Error Localization with Gradual
Recovery*, submitted to ICFP 2023.

## Contents

The following is an overview of the contents of this zip:

-   [supplement.pdf](./supplement.pdf) contains the complete formalism for the marked lambda
    calculus, the Hazelnut action semantics, and appendices for the type hole inference work.

-   [agda/](./agda/) contains the Agda mechanization of the marked lambda calculus. See [its
    README](./agda/README.md) for more detail.

-   [hazel/](./hazel/) contains a snapshot build of the Hazel implementation with type hole
    inference support. For more detail, see [below](#hazel-with-type-hole-inference).

### Hazel with Type Hole Inference

The included snapshot build of Hazel has support for type hole inference. To try it out, open
[hazel/index.html](./hazel/index.html) in a web browser.
