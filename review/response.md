Thank you for your thoughtful and detailed comments! We believe that the issues raised can be
addressed with only small revisions.

# Extensions (RA, RB, RD)

The reviews suggested extensions of the marked lambda calculus to handle polymorphism (RA, RD),
linear types (RB), dependent types (RB), and subtyping (RD). Our intention was to present a minimal
framework that, like the STLC, is intended to establish guiding metatheory–most importantly,
totality–in support of conservative extensions in many subsequent directions. We dedicate Sec. 2.2
and 2.3 to two small examples of such extensions, emphasizing how totality guides us. We do
similarly consider System-F-style polymorphism in Sec. 2.5, albeit less formally for space reasons;
we would be happy to use an extra page in the final version to include the straightforward rules for
“marked System F” if requested.

We conclude Sec. 2.5 with a perhaps too brief discussion of more sophisticated extensions, e.g.
implicit type application. We would be happy to more explicitly lay out the general approach, which
is still to first define a bidirectional + gradual version of the feature, then use totality as a
guide. We will cite relevant work on gradual implicit type application [1], gradual dependent types
[2], and gradual subtyping [3] in the final version of this section; we aren’t aware of a gradual
linear type system, though there are gradual session type systems [4]. However, it is beyond the
scope of this initial paper to define marked dialects of these systems, which each comprise dozens
of typing rules.

Our implementation does scale beyond the calculus to those features found in ML-family languages
like Elm, e.g. full pattern matching.

We agree that marked dialects of advanced type systems might require a designer to experiment with
different localization heuristics when errors are due to a confluence of factors (e.g. as in Sec.
2.1.6 with conditionals). Our contribution is to provide a framework for clearly specifying these
design decisions, rather than leaving them implementation-defined.

# Mechanizing constraint solving / Sec. 4 contributions (RB, RC, RD)

While there are several mechanizations of unification-based type inference (e.g. [5]), the
metatheory of these systems (e.g. soundness, principality) is relevant only when the constraint set
is consistent. Our focus in Sec. 4 is on inconsistent constraints: suggested fillings can be
inconsistent with the constraints. There is no critical metatheorem, like totality, that must guide
this development; the approach in Sec. 4 is instead fundamentally rooted in the heuristic that even
inconsistent constraints likely contain information about user intent. The key technical challenge
is therefore in efficiently computing partially consistent suggestions, so we intentionally favored
an algorithmic presentation in Sec. 4.4.

We also intentionally used simple, well-studied techniques, like union find, because the real
contribution of Sec. 4 is the system architecture: we demonstrate that one can dramatically clean up
type error localization by using constraint solving only for localizing erroneous type holes,
layering it atop a bidirectional + gradual core where localizing erroneous expressions is more
systematic. Previously, these approaches were seen as alternatives. We agree that Sec. 4 could use a
clearer “punchline” along these lines (RC, RD) and general clarity improvements (many suggested by
the reviewers).

# Related work: interleaving (RA)

We agree that the approach taken in contemporary constraint-based type inference implementations,
cited by RA [6, 7], of interleaving constraint generation and solving could inform efforts to
interleave marking (Sec. 2) and constraint solving (Sec. 4). However, because Sec. 2 can be adopted
on its own, we believe that introducing these topics separately, based on more elementary and
widely-understood foundations (e.g. STLC, HM) is expositionally preferable. We will discuss.

# Empirical evaluation (RB, RC)

The primary contribution of Sec. 2 is a metatheoretic framework, so our primary evaluation of this
contribution is the mechanized metatheory. While it would be interesting for future work to, for
example, empirically evaluate different approaches to localizing inconsistencies between conditional
branches, we make no specific usability claims and formalize each possible approach.

The primary contribution of Sec. 4 is a novel architecture, described above, that simplifies and
systematizes a previously complex and ad hoc task: constraint inconsistency error localization.
Certainly it would be interesting to empirically evaluate the “code completion” affordance we
present that allows quick toggling between partially consistent type hole fillings, but we again
make no specific usability claims about this particular interface. It is optional and can be toggled
off without any loss of liveness elsewhere in the system, which relies only on the localization
mechanisms detailed in Sec. 2.

We have deployed Hazel in the classroom recently, so we hope to observe how students interact with
all aspects of the relevant affordances, including localization choices, error messages, and code
completions, over the coming years, but we believe that the metatheoretic and architectural
contributions of this paper open up an interesting and novel region in the design space on their
own. We will be careful to make clear that there are no specific HCI claims related to the UI
screenshots or specific error message text in this paper.

# What is “gradual recovery”? (RC, RD)

We will clarify in the introduction that by “gradual recovery” we refer to our use of gradual typing
to both recover from missing type information (pg. 3, Sec. 2) and to provide a site for
interactively recovering from conflicting constraints (pg. 4, Sec. 4).

# Motivation for Sec 3 (RA, RD)

Section 3 is a short section pointing out that marking allows us to resolve a significant problem
related to undefined behavior in the Hazelnut edit action calculus. We introduce the judgemental
forms but indeed, a deep understanding of this section would require familiarity with Hazelnut. We
can note that this section can be safely skipped for readers uninterested in formal models of
structure editing. (It can also be omitted from the final version if requested.)

# Additional Responses

We respond to some more specific questions brought up by each reviewer below.

## RA

    A good part of the early presentation is a bit repetitive in nature, and could be summarized by
    stating that valid unmarked typing derivations are left as-is in the marked word. Is that
    correct?

Yes, this is formalized with Theorem 2.3, part 1. We can mention this sooner.

    Why aren't destructuring bindings implemented like this at all? The proposed way seems much more
    complicated, more expansive, and it's unclear to me why it would provide better error messages.

Sec. 2 is intended as a standalone system that does not incorporate constraint solving, so this was
not an option. We included this in the paper because a strictly bidirectional approach is indeed
rather subtle and we hadn’t previously seen this issue brought up, e.g. in Dunfield’s 2018 review
paper. The approach we specify ensures that information from both the expression and pattern is
unified, while taking pattern type annotations as “ground truth” for localizing errors in the
expression. Sec. 4’s approach would generate the constraints as RA describes.

    The use of ?u for unification variables confuses me a lot. It seems to mix up unification
    variables with the gradual unknown, which seems completely wrong to me. A gradual unknown is any
    type (possibly several different ones during the execution), a unification variable is a single
    type that isn't determined yet. Am I missing something motivating your usage? (RA)

We consider missing type annotations type holes for the purposes of inference, i.e. we presume the
user intends to fill type holes with a known type. To expose gradual typing for intentional use, we
could introduce a “dyn” type that would fill a type hole and behave identically except that it would
not be subject to type hole filling. (This is related to the approach explored by Garcia and Cimini,
which was mentioned by RD.)

    If I remember correctly, Elm also uses this graph to diagnose type errors, by recognizing
    specific patterns in the graph of types and/or constraints. Is that something you do as well,
    and can you develop a bit on that? (RA)

We take the opposite approach, as we described above. Briefly, we do not attempt to try to localize
constraint solving failures to expressions, leaving that to the marking system. This avoids the need
to define this style of ad hoc system – type inference variables that cannot be solved can be
systematically localized to type holes, and the user can interactively choose from partial fillings
to see where the problem would be localized in a second step.

# RB

    can I essentially think of this as type checking, but that it will always produce a type where
    there may nevertheless be marks to indicate the location of type errors? And an unmarked
    expression is not necessarily well typed but is well formed?

Yes, precisely!

# RC

    Why are your rules algorithmic? (RC)

The rules are incidentally algorithmic from our perspective – bidirectional typing is useful because
it specifies a static “direction” that information flows, which thereby systematizes error
localization. In addition, we want to ensure unicity, i.e. that there are not multiple possible
markings, because our goal is to formalize what would normally be an implementation decision.

# RD

    Could you clarify what would happen if a conditional would be subsumable? (RD)

This would violate unicity (i.e. make marking non-deterministic) in the case where a conditional
expression with inconsistent branches appeared in an analytic position, e.g.

```
let x : Num = tt ? ff : 2
```

The analysis rule would mark the error on the “then” branch, while the synthesis rule would mark the
error on the conditional as a whole (or arbitrarily on one of the branches if the alternative rules
are used).

## Related Work (RD)

Thank you for bringing up some more distantly related work on type inference, which we respond to
below. We will include this in the final related work section.

    Garcia and Cimini's POPL 2015 paper on type inference for gradually-typed languages, which
    improves substantially on the prior work of Siek and Vachharajani.

Indeed, this paper is a cleaner presentation of the approach explored initially by Siek and
Vachharajani. It distinguishes explicit unknowns from types that must be inferred, whereas we
consider type holes as types that need to be inferred (and also allow other internally generated
unknowns to be inferred, with full provenance). We could add a “dyn” type to allow users to mark
that they intend the gradual unknown semantics and do not want a solution to be inferred (see
response to RA above) which would be consistent with Garcia and Cimini. This paper does not consider
the key problem we focused on, which is generating partial solutions, but we agree that this paper
should be discussed in more detail alongside Siek and Vachharajani in the final version.

    The second is Vazoy et al's OOPSLA 2018 paper on gradual liquid type inference, which features a
    similar treatment of holes and interactive exploration of possible solutions (in that case, for
    unknown refinements, but the underlying concepts are very close).

We agree that the liquid type exploration outlined in this paper is similar in spirit to our
approach in that it allows for interactive exploration of conflicting refinement type constraints,
localized to holes in a refinement type specification. Marking is not detailed in this paper, and
the technical approach to synthesizing refinements is quite different, but we will certainly mention
that the exploratory interface we propose has connections to this prior work!

    Also, Lennon-Bertrand et al.'s TOPLAS 2022 paper on Gradual CIC includes an integration of
    bidirectional typing and gradual typing.

We mention this at the beginning of the author response – we agree that this system would be a
suitable basis for creating a marked CIC and look forward to future explorations in this direction!

[1] Xie et al, 2019 (based on Dunfield and Krishanswami, 2013)

[2] Lennon-Bertrand et al, 2022

[3] Siek and Taha, 2007

[4] Igarashi et al, 2017

[5] Paulson, 1993 (and several other subsequent efforts, which we will cite as well)

[6] Odersky et al, 1999

[7] Pottier, 2014
