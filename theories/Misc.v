(* This program is free software; you can redistribute it and/or      *)
(* modify it under the terms of the GNU Lesser General Public License *)
(* as published by the Free Software Foundation; either version 2.1   *)
(* of the License, or (at your option) any later version.             *)
(*                                                                    *)
(* This program is distributed in the hope that it will be useful,    *)
(* but WITHOUT ANY WARRANTY; without even the implied warranty of     *)
(* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the      *)
(* GNU General Public License for more details.                       *)
(*                                                                    *)
(* You should have received a copy of the GNU Lesser General Public   *)
(* License along with this program; if not, write to the Free         *)
(* Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA *)
(* 02110-1301 USA                                                     *)


(***********************************************************************
    Proof of Bertrand's conjecture: Misc.v
                                         Laurent.Thery@inria.fr (2002)
  *********************************************************************)
From Coq Require Import Arith ArithRing.
From Bertrand Require Export sTactic.

(** Some facts about arithmetics *)

Theorem lt_mult_right : forall x y z t : nat, x < z -> y < t -> x * y < z * t.
Proof.
intros x y z t; case x; case z.
intros H'; Contradict H'; auto with arith.
simpl in |- *; intros n H'; case t; auto with arith.
intros H'0; Contradict H'0; auto with arith.
intros n H'; Contradict H'; auto with arith.
intros n n0 H'; case t.
intros H'0; Contradict H'0; auto with arith.
intros n1 H'0; apply Nat.lt_trans with (m := S n0 * S n1); auto with arith.
rewrite (Nat.mul_comm (S n0)); rewrite (Nat.mul_comm (S n)); auto with arith.
Qed.

Theorem le_mult_right : forall x y : nat, 0 < y -> x <= x * y.
Proof.
intros x y; case y.
intros H'; Contradict H'; auto with arith.
intros n H'; rewrite Nat.mul_comm; simpl in |- *; auto with arith.
Qed.
 
Lemma lt_minus_O_lt : forall n m : nat, m < n -> 0 < n - m.
Proof.
intros n m H'.
apply Nat.add_lt_mono_l with (p := m).
rewrite (Nat.add_comm m (n - m)).
rewrite Nat.sub_add; auto with arith.
rewrite Nat.add_0_r; auto.
Qed.
 
Lemma eq_minus : forall a b c : nat, c < a -> a - c = b - c -> a = b.
Proof.
intros a b c H' H'0.
rewrite <- (Nat.sub_add c a); auto with arith.
rewrite <- (Nat.sub_add c b); auto with arith.
apply Nat.lt_le_incl.
apply (Nat.lt_add_lt_sub_r 0).
rewrite <- H'0; auto.
apply lt_minus_O_lt; auto.
Qed.

Lemma eq_minus' :
 forall a b c : nat, c <= a -> c <= b -> a - c = b - c -> a = b.
Proof.
intros.
rewrite <- (Nat.sub_add c a); auto with arith.
rewrite H1.
rewrite Nat.sub_add; auto.
Qed.
 
Lemma eq_plus : forall a b c : nat, c + a = c + b -> a = b.
Proof.
intros a b c H'.
apply Nat.add_cancel_l with (p := c); auto.
Qed.

Lemma plus_eqO : forall x y : nat, x + y = 0 -> x = 0.
Proof.
intros x; case x; simpl in |- *; auto.
intros x' y; case y; simpl in |- *; intros; discriminate.
Qed.

Lemma mult_eqO : forall a b : nat, a * b = 0 -> a = 0 \/ b = 0.
Proof.
intros x; case x; simpl in |- *; auto.
intros x' y; case y; simpl in |- *; auto; intros; discriminate.
Qed.

Lemma mult_SO : forall x y : nat, x * y = 1 -> x = 1.
Proof.
intros x; case x; simpl in |- *; auto.
intros x' y; case y; simpl in |- *; auto.
rewrite Nat.mul_comm; intros; discriminate.
intros n H'; case (mult_eqO x' (S n)).
apply plus_eqO with (y := n).
rewrite Nat.add_comm; apply eq_add_S; auto.
intros H'0; rewrite H'0; auto.
intros; discriminate.
Qed.

Lemma mult_eq_Sn : forall a b : nat, 0 < b -> a * b = b -> a = 1.
Proof.
intros a b; case b; simpl in |- *; auto.
intros H; Contradict H; auto with arith.
case a; simpl in |- *; auto.
intros; discriminate.
intros b' a' H' H'1; case (mult_eqO b' (S a')); auto.
apply Nat.add_cancel_l with (p := S a'); simpl in |- *; rewrite <- plus_n_O; auto.
intros H'0; Contradict H'0; auto; rewrite H'0; auto with arith.
Qed.

Theorem simpl_mult_r : forall n m p : nat, 0 < n -> m * n = p * n -> m = p.
Proof.
intros n m; elim m; simpl in |- *; auto.
intros p H' H'0; case (mult_eqO p n); auto.
intros H'1; Contradict H'; auto; rewrite H'1; auto with arith.
intros m' H' p; case p; simpl in |- *; auto.
case n; simpl in |- *; try (intros; discriminate); intros H1; Contradict H1;
 auto with arith.
intros p' H'0 H'1.
rewrite (H' p'); auto.
apply Nat.add_cancel_l with (p := n); auto.
Qed.

Lemma eq_mult : forall a b c : nat, c <> 0 -> c * a = c * b -> a = b.
Proof.
intros a b c; case c; auto.
intros H'; case H'; auto.
intros n H' H'0; apply simpl_mult_r with (n := S n);
 repeat rewrite Nat.mul_comm with (m := S n); auto with arith.
Qed.
 
Lemma le_plus_le : forall a b c d : nat, a <= b -> a + c = b + d -> d <= c.
Proof.
intros.
cut (c = b - a + d).
intros H1; rewrite H1.
auto with arith.
apply Nat.add_cancel_l with (p := a); auto.
rewrite Nat.add_assoc.
rewrite (Nat.add_comm a (b - a)).
rewrite Nat.sub_add; auto.
Qed.

Lemma plus_minus_assoc : forall a b c : nat, b <= a -> a - b + c = a + c - b.
Proof.
simple induction c.
repeat rewrite Nat.add_comm with (m := 0); simpl in |- *; auto with arith.
intros n H0 H1; repeat rewrite <- plus_n_Sm.
rewrite H0; auto with arith.
Qed.

Theorem lt_mult_right_anti : forall x y z : nat, z * x < z * y -> x < y.
Proof.
intros x y z H0; case (Nat.le_gt_cases y x); auto; intros H1.
contradict H0; auto; apply Nat.le_ngt; auto with arith.
Qed.

Theorem mult_lt_bis : forall p q r : nat, 0 < r -> p < q -> r * p < r * q.
Proof.
intros p q r; case r; auto with arith.
Qed.
#[export] Hint Resolve mult_lt_bis: arith.
 
Theorem lt_O_mult : forall p q : nat, 0 < p -> 0 < q -> 0 < p * q.
Proof.
intros p q H1 H2; inversion H1; inversion H2; simpl in |- *; auto with arith.
Qed.
#[export] Hint Resolve lt_O_mult: arith.
 
Theorem minus_plus_le :
 forall a b c d : nat, a <= c -> b <= d -> c + d - (a + b) = c - a + (d - b).
Proof.
intros a b c d H H0.
apply Nat.add_sub_eq_l.
apply trans_equal with (a + (c - a) + (b + (d - b))); auto with arith; ring.
Qed.
 
Theorem minus_O : forall a b : nat, a <= b -> a - b = 0.
Proof.
intros a; elim a; simpl in |- *; auto with arith.
intros a1 Rec b; case b; elim b; auto with arith.
Qed.

Theorem minus_le : forall a b c : nat, a <= b + c -> a - c <= b.
Proof.
intros a b c H; apply (fun p n m : nat => Nat.add_le_mono_l n m p) with (p := c).
case (Nat.le_gt_cases a c); intros H1.
replace (a - c) with 0; auto with arith.
apply sym_equal; apply minus_O; auto with arith.
rewrite Nat.add_comm, Nat.sub_add; auto with arith.
rewrite Nat.add_comm; auto with arith.
Qed.

(** A generic function to find the maximal natural number such that
      the property P hols *)
 
Fixpoint max_such (P : nat -> Prop) (P_dec : forall n : nat, {P n} + {~ P n})
 (n : nat) {struct n} : nat :=
  match P_dec n with
  | left _ => n
  | right _ => match n with
               | O => 0
               | S n1 => max_such P P_dec n1
               end
  end.

Theorem max_such_prop :
 forall (P : nat -> Prop) (P_dec : forall n : nat, {P n} + {~ P n}) (n : nat),
 (exists x : nat, x <= n /\ P x) ->
 max_such P P_dec n <= n /\
 P (max_such P P_dec n) /\
 (forall x : nat, max_such P P_dec n < x -> x <= n -> ~ P x).
Proof.
intros P P_dec n; elim n; simpl in |- *; auto.
intros (x1, (H1, H2)).
case (P_dec 0); auto.
intros H3; repeat split; auto; intros x H4 H5; inversion H5; auto.
Contradict H5; auto with arith; rewrite H; auto with arith.
intros H3; Contradict H2; auto; inversion H1; auto.
intros n1 Rec (x1, (H1, H2)); case (P_dec (S n1)); auto.
intros H3; repeat split; auto with arith.
intros x H H0; (Contradict H0; auto with arith).
intros H3; case Rec.
exists x1; split; auto with arith.
inversion H1; auto.
case H3; rewrite <- H; auto.
intros H4 (H5, H'5); repeat split; auto.
intros x H6 H7; auto.
inversion H7; auto with arith.
Qed.

Definition le_dec : forall n m : nat, {n <= m} + {~ n <= m}.
intros n m; case (le_lt_dec n m); auto.
intros H1; right; auto with arith.
Defined.
 
Theorem not_le_lt : forall n m : nat, ~ n <= m -> m < n.
Proof.
intros n m H1; case (Nat.le_gt_cases n m); auto; intros H2; case H1; auto.
Qed.

Theorem odd_or_even :
 forall n : nat,
 (exists x : nat, n = 2 * x) \/ (exists x : nat, n = 2 * x + 1).
Proof.
intros n; elim n.
left; exists 0; auto.
intros n1 [(x1, H1)| (x1, H1)]; [ right | left ]; rewrite H1; auto with arith.
exists x1; ring.
exists (x1 + 1); simpl in |- *; repeat (rewrite <- plus_n_Sm; simpl in |- *);
 repeat (rewrite <- plus_n_O; simpl in |- *); auto.
Qed.

Theorem le_mult : forall m n p q : nat, n <= p -> m <= q -> n * m <= p * q.
Proof.
intros m n p q H1 H2; apply Nat.le_trans with (p * m); auto with arith.
repeat rewrite (fun x => Nat.mul_comm x m); auto with arith.
Qed.

Theorem mult_id_le_inv : forall n m : nat, n * n <= m * m -> n <= m.
Proof.
intros n m H; case (Nat.le_gt_cases n m); auto; intros H1; contradict H;
 apply Nat.lt_nge.
apply Nat.le_lt_trans with (n * m); auto with arith.
apply le_mult; auto with arith; apply Nat.lt_le_incl; auto.
apply mult_lt_bis; auto with arith; apply Nat.le_lt_trans with (2 := H1);
 auto with arith.
Qed.

Theorem mult_id_lt_inv : forall n m : nat, n * n < m * m -> n < m.
Proof.
intros n m H; case (Nat.le_gt_cases m n); auto; intros H1; contradict H;
 apply Nat.le_ngt.
apply Nat.le_trans with (n * m); auto with arith.
apply le_mult; auto with arith.
Qed.
(*****************************************************************
                        Definition of ominus                    
  *****************************************************************)
 
(** ominus computes the difference of two nat. 
    (ominus n m) = (Some O) iff n = m 
*)
Fixpoint ominus (m : nat) : nat -> option nat :=
  fun n =>
  match m, n with
  | _, O => Some m
  | O, _ => None
  | S m1, S n1 => ominus m1 n1
  end.
(*****************************************************************
                        Properties of  ominus                   
  *****************************************************************)

Theorem ominus_def :
 forall m n : nat,
 match ominus m n with
 | Some q => m = n + q
 | None => m < n
 end.
Proof.
intros m; elim m; simpl in |- *; auto with arith.
intros n; case n; simpl in |- *; auto with arith.
intros m1 Rec n; case n; simpl in |- *; auto with arith.
intros n1; generalize (Rec n1); case (ominus m1 n1); simpl in |- *;
 auto with arith.
Qed.

Definition le_dec1 : forall n m : nat, {n <= m} + {~ n <= m}.
intros n m; generalize (ominus_def m n); case (ominus m n).
intros n0 H; left; rewrite H; auto with arith.
intros H; auto with arith.
Defined.
(*****************************************************************
                        Definition of  sqr                      
  *****************************************************************)
 
(** sqr computes the square root of a number *)
Definition sqr (n : nat) :=
  max_such (fun x => x * x <= n) (fun x => le_dec1 (x * x) n) n.
(*****************************************************************
                        Properties of  sqr                      
  *****************************************************************)

Theorem sqr_le : forall n : nat, sqr n * sqr n <= n.
Proof.
intros n; unfold sqr in |- *;
 generalize
  (max_such_prop (fun x => x * x <= n) (fun x => le_dec1 (x * x) n) n);
 case (max_such (fun x => x * x <= n) (fun x => le_dec1 (x * x) n)).
simpl in |- *; intros H1; case H1; auto with arith.
exists 0; split; auto with arith.
intros n0 H; case H; auto with arith.
exists 0; split; auto with arith.
intros H2 (H3, H4); auto.
Qed.

Theorem sqr_lt : forall n : nat, n < S (sqr n) * S (sqr n).
Proof.
intros n; unfold sqr in |- *;
 generalize
  (max_such_prop (fun x => x * x <= n) (fun x => le_dec1 (x * x) n) n);
 case (max_such (fun x => x * x <= n) (fun x => le_dec1 (x * x) n)).
case n; auto with arith.
intros n0 H; case H; auto with arith.
exists 0; split; auto with arith.
intros H2 (H3, H4); auto.
apply not_le_lt; auto with arith.
intros n0 H; case H; auto with arith.
exists 0; split; auto with arith.
intros H2 (H3, H4); auto.
apply not_le_lt; auto with arith.
case ((proj1 (Nat.lt_eq_cases _ _)) H2); intros H5.
apply H4; auto with arith.
rewrite H5; auto with arith.
apply Nat.lt_nge; auto with arith.
apply Nat.lt_le_trans with (S n); auto with arith.
pattern (S n) at 1 in |- *; replace (S n) with (S n * 1); auto with arith.
Qed.

Theorem sqr_inv : forall n m : nat, m * m <= n -> n < S m * S m -> sqr n = m.
Proof.
intros n m H1 H2.
case (proj1 (Nat.lt_eq_cases 0 m)); auto with arith; intros H3.
cut (m <= n); [ intros H4 | idtac ].
unfold sqr in |- *;
 generalize
  (max_such_prop (fun x : nat => x * x <= n)
     (fun x : nat => le_dec1 (x * x) n) n);
 case
  (max_such (fun x : nat => x * x <= n) (fun x : nat => le_dec1 (x * x) n) n).
intros H5; case H5.
exists m; auto with arith.
intros H6 (H7, H8); case (H8 m); auto with arith.
intros n0 H.
case H; auto with arith.
exists m; auto with arith.
intros H5 (H6, H7).
case (proj1 (Nat.lt_eq_cases (S n0) m)); auto with arith.
apply Nat.lt_succ_r; apply mult_id_lt_inv.
apply Nat.le_lt_trans with (1 := H6); auto with arith.
intros H0; case (H7 m); auto with arith.
apply Nat.le_trans with (2 := H1); auto with arith.
apply Nat.le_trans with (m * 1); auto with arith.
rewrite Nat.mul_1_r; auto with arith.
rewrite <- H3; rewrite <- H3 in H2; simpl in H2; inversion H2.
simpl in |- *; auto.
inversion H0.
Qed.

Theorem sqr_mult2 : forall n : nat, sqr (n * n) = n.
Proof.
intros n; apply sqr_inv; auto with arith.
apply Nat.le_lt_trans with (S n * n); auto with arith.
simpl in |- *; auto with arith.
Qed.

Theorem sqr_mono : forall n m : nat, n <= m -> sqr n <= sqr m.
Proof.
intros n m H; elim H; auto with arith.
intros m0 H0 H1.
apply Nat.le_trans with (1 := H1).
apply Nat.lt_succ_r; apply mult_id_lt_inv.
apply Nat.le_lt_trans with m0.
apply sqr_le; auto.
apply Nat.lt_trans with (S m0); auto with arith; apply sqr_lt; auto.
Qed.
