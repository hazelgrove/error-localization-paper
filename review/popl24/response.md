Thank you for your thoughtful and detailed comments. We address questions brought up by the reviewers below. The issues raised can be addressed with revisions that will correct the typos and small expositional clarity issues identified by the reviewers and expand on the discussion of the design space, as suggested by the reviewers.

# Review A

> In the rules you have chosen τ₁ from the environment. I would argue that τ is the more natural
> choice from the programmer's point of view (that's what they wrote!) and ? is the more principled
> one. At the very least, you need to acknowledge that there is a choice to make here.

This is actually a typo—indeed, we agree that it is more natural to choose τ (and in fact this is
the choice found in the Agda mechanization)! We will fix this in the final version and, in general,
more clearly highlight these spots where language designers must make such decisions.

> It's not clear at all why the first two premises [of USLetPat] (involving τp) are needed at all,
> since no information flows out of them.

Yes, those two premises are unnecessary. They were included as, following the marking logic from
ISLetPat, we must ultimately analyze the definition against the pattern type to properly attribute
any inconsistency error to the definition, given that we want any annotations in the pattern to be
canonical. However, for USLetPat, the analysis of the pattern against the definition type suffices
to ensure consistency, so the second and hence the first premise are redundant, and will be removed
from the final version, where we will clarify this point.

> Is the correspondence between this approach to polymorphism (using the gradual unknown type for
> unification variables) and standard Hindley-Milner known? Are there any systems implementing this
> currently?

Garcia and Cimini (2015) have previously developed the connection between polymorphism, gradual
typing, and constraint-based (Hindley-Milner) type inference. We discussed this paper in the Related
Work section, but will also mention it alongside Siek and Vachharajani (2008) in Section 4.4 in the
final version (and expand our discussion of it in the Related Work section).

> In section 3.1 you write that you have implemented marking for algebraic datatypes and explicit
> polymorphism, but there are no examples for this in the supplied Hazel build, and I can't figure out
> what the syntax is.

These features were in different branches of Hazel at submission time, so they did not end up in the
build provided in the submitted supplement. They will be merged in the final artifact. We will also
include an Examples tab in the UI which will demonstrate the relevant syntax.

# Review B

> Lines 644-645 say that "[i]f the pattern a suggests that the conditional is in synthetic position,
> it will be marked with an inconsistent branches error mark following our development above. If
> instead it is in analytic position against the unknown type, no mark will be produced." Is this
> desirable? I would expect to get a type error pointing out inconsistent branch types regardless of
> how the expression is type checked.

The gradually typed interpretation of type holes as the unknown (i.e. dynamic) type suggests
allowing each branch to be checked independently (as only one of the branches will be taken at
run-time). It is essentially as if each branch was independently annotated with a ? type ascription,
which would cause both branches to become consistently typed. The inconsistency between branches
would still be caught by the type hole inference mechanism described in Section 4, localizing the
problem to the ? itself. We will clarify this in the final version.

> Have you thought about how this (e.g., Section 2.1.1) would work with operator overloading (e.g.
> if you add a float type and overload + to operate on both ints and floats?)

Overloading would require changing one or both operand modes to synthetic (depending on how operator
overloading is defined—the left operand is often arbitrarily privileged in languages with this
feature) so that the overloading can be resolved during typing/marking. If an operator is not
defined given the synthesized type of the operand(s), the error might be marked on the operator
itself. Type classes (a.k.a. traits / implicits) present a symmetric alternative to operator
overloading where the operands can remain in analytic position. We will briefly discuss this
situation in the final version.

> I accept that producing error messages was not the focus of the paper, but are there more general
> lessons you can draw on error localization (e.g., for other languages/paradigms, or if one wants to
> do better error localization but without buying fully into the mechanisms of typed holes)?

The marked lambda calculus relies in some instances on having an unknown type à la gradual typing
(which has been studied and applied across many language paradigms, including imperative / OO
languages). However, we will note more clearly that empty expression holes are not integral to the
core calculus and recipe—they are included to illustrate how the marked lambda calculus fits into
the larger problem of modeling incomplete program states and to discuss polymorphic generalization
in Section 4.4, but could be removed entirely from the marked lambda calculus without issue. As
such, the techniques described in the paper should be relevant to a wide variety of language
designs, including those where hole-driven development is not part of the user workflow.

# Review C

> line 288: I was expecting some kind of "Localisation" principle about pushing errors to
> a maximally local position. Is that not possible? It seems related to "the neutral approach."

We did not consider the problem of measuring locality but we note that the typing rules for marks
ensures that the marks are placed precisely at locations where inconsistencies exist, and therefore
less local marks (e.g. on parent expressions) would violate the metatheory. Bidirectional typing
specifies a flow of typing information that ultimately justifies the localization decisions in the
marked lambda calculus; the justification for the type flow of bidirectional typing is discussed by
other authors, notably Dunfield and Krishnaswami (2019).

> line 442: what would break if you synthesized the body in the premise of the rule rather than
checking against? Anything? Is there a guiding principle around this?

It is indeed possible to instead synthesize the body here, but we chose analysis because the overall
lambda is in analytic position so, were the expected type an arrow type, the body would be in
analytic position and therefore we retain this mode using the unknown type. The design principle
here is perhaps some notion of “conservation of mode”, which we can discuss in the final version,
but it is not critical here.

> line 452: In the premise of MKALAM3, why is x typed \tau_1, as opposed to \tau or "?"? What is the
> guiding principle at play here?

As mentioned above in response to a similar question in Review A, this is actually a typo, and
indeed we believe it more natural to choose τ (and this choice is the one found in the Agda
mechanization). This will be corrected in the final version.

> line 458: In the USAp rule, is it necessary for e2 to be checked against \tau_1? Is it plausible
> to instead synthesize the argument type and then "half-check/half-synthesize" the function? It would
> be nice to understand what the boundaries of this design are.

We are not entirely sure what is meant by “half-check/half-synthesize”, but our development of the
unmarked typing rules follow the typical formulation of function application in bidirectional
typing. Dunfield and Krishnaswami (2019) discuss other “modes” for function application where
information could flow in other directions, and if these alternatives were chosen, error
localization would need to be updated accordingly.

> line 531: Why must localization be deterministic? Given the number of design decisions involved,
> is it plausible to defer them or choose in some delayed manner, or by using more program context
> to decide?

The algorithmic and deterministic nature of the localization calculus makes it straightforward to
implement as part of a real type checker. Ultimately, how errors are localized depends heavily on
the formulation of the original type system. However, it may be possible to involve the user or
other heuristic mechanisms to resolve ambiguity rather than specifying a decision
deterministically—we explore this in concept in Section 4 for type inference errors in particular,
and will mention it more broadly as a potential direction for future research.

> Section 2.3 seems to reuse the ? type to model phenomena that should make sense in a language that
> is bidirectionally-typed, has pattern matching, and has no notion of gradual typing whatsoever.
> I think that this would be a much better contribution if it started with explicating a purely static
> version of bidirectional pattern matching and then demonstrated that the marking recipe transfers
> over to this purely-static version. I expect that such a system would need some way of accounting
> for partial analysis and synthesis, but without using gradual typing (albeit something related but
> static).

The type ?⇒ for switching to synthesis does indeed not require gradual typing and is merely
a marker for switching to synthesis because we are using analysis to propagate information from the
pattern. It never needs to participate in a type consistency relation (via subsumption) because the
UASynSwitch rule would always apply there. It need not look like an unknown type, i.e. using ? may
be misleading notation, so we will clarify this as suggested in the final version.

> line 678: the USLETPAT rule seems to depend on all expressions being able to synthesize, which is
> not the case in all bidirectional systems (e.g. the common treatment of unannotated lambdas). Can
> this be generalized?

Yes, we do assume that successful analysis implies synthesis, but a more general treatment here
would choose to use the pattern’s synthesized type to analyze the bound expression in situations
where no type can be synthesized. We will describe this design dimension in the final version.

> line 730: "these marked types operate identically..." why is that the "right" thing to do? What is
> the guiding principle (aside from it seeming to work)?

In the same way that unbound variables and other error-marked expressions in our core development
synthesized the unknown type to allow type-checking to continue, so too do unbound type variables
behave like the unknown type.

> line 816: what is the box superscript?

This is mark erasure, as defined in Figure 3.

> line 828: I find it strange to call bidirectional typing "local type inference" since local type
> inference (at least in Pierce and Turner) was a combination of bidirectional typing and constraint
> solving.

We will make this distinction more clear in the final version.

> line 884: What is the red angle bracket? I didn't see it explained.

The editor cursor in Hazel is drawn as an angle bracket at expression boundaries to convey the
“hexagonal block structure” of Hazel expressions (see Moon et al, VL/HCC 2023 for details – we will
clarify in the final version).

> line 963: "without needing to introduce explicit constraints" I did not understand this, since the
> rules seem to be adding explicit constraints.

We will clarify that the purpose of the matched arrow provenances here is to avoid generating fresh
type inference variables each time a matched arrow type is invoked, which would lead to a blow up in
the number of inference variables that must necessarily be equal to one another.

> line 969: "A marked expression has already been deemed erroneous" but why is it the expression,
> rather than the boundary between outside and inside?

The bidirectional flow in Section 2 determines expression error localization, and indeed it is
typically due to inconsistencies between the type information “outside” and “inside” the marked
expression that causes issues.

> line 982: "a standard union-find based unification algorithm" but this algorithm must account for
> consistency, right?

Yes, the algorithm favors more precise types as previously described e.g. by Siek and Vahharajani
(2008) and Garcia and Cimini (2015). We will make this point more clear.
