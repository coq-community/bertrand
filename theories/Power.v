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
    Proof of Bertrand's conjecture: Power.v
                                         Laurent.Thery@inria.fr (2002)
  *********************************************************************)

From Coq Require Import Arith ArithRing.
From Bertrand Require Export Misc.

(**  (power x n) computes x to the power n *)

Fixpoint power (x n : nat) {struct n} : nat :=
  match n with
  | O => 1
  | S n' => x * power x n'
  end.

Theorem power_SO : forall x : nat, power x 1 = x.
Proof.
simpl in |- *; intros x; rewrite Nat.mul_1_r; auto.
Qed.

Lemma power_lt_O : forall x n : nat, 0 < x -> 0 < power x n.
Proof.
simple induction n; simpl in |- *; auto with arith.
Qed.

Lemma power_le : forall x n : nat, 0 < n -> x <= power x n.
Proof.
intros x n; case n; simpl in |- *; auto.
intros H'; inversion H'.
intros n'; case x; intros; auto.
apply le_mult_right; auto.
apply power_lt_O; auto with arith.
Qed.

Lemma power_mult :
 forall x a b : nat, power x a * power x b = power x (a + b).
Proof.
simple induction a; simpl in |- *; auto.
intros n H' b; rewrite <- Nat.mul_assoc; rewrite H'; auto.
Qed.

Lemma power_power : forall x a b : nat, power (power x a) b = power x (a * b).
Proof.
simple induction b; simpl in |- *; auto.
rewrite Nat.mul_comm; simpl in |- *; auto.
intros n H'; rewrite Nat.mul_comm with (m := S n); simpl in |- *;
 rewrite (Nat.mul_comm n); rewrite H'; apply power_mult.
Qed.

Lemma SO_power : forall x : nat, power 1 x = 1.
Proof.
simple induction x; simpl in |- *; auto.
intros n H'; rewrite H'; auto.
Qed.

Lemma power_O : forall n : nat, 1 <= n -> power 0 n = 0.
Proof.
simple induction n.
intros H1; Contradict H1; auto with arith.
intros; simpl in |- *; auto.
Qed.

Theorem power_lt_mono :
 forall p q r : nat, 1 < r -> p < q -> power r p < power r q.
Proof.
intros p q r H H0; elim H0; simpl in |- *; intros; auto with arith;
 pattern (power r p) at 1 in |- *; replace (power r p) with (1 * power r p);
 auto with arith.
repeat rewrite (fun x y z => Nat.mul_comm x (power y z)); auto with arith.
apply mult_lt_bis; auto with arith.
apply power_lt_O; auto with arith.
apply lt_mult_right; auto with arith.
Qed.

Theorem power_le_mono :
 forall p q r : nat, 0 < r -> p <= q -> power r p <= power r q.
Proof.
intros p q r H; inversion H; auto with arith.
repeat rewrite SO_power; auto with arith.
intros H2; case ((proj1 (Nat.lt_eq_cases _ _)) H2); auto; intros H3.
apply Nat.lt_le_incl; apply power_lt_mono; auto with arith.
rewrite H3; auto.
Qed.

Theorem power_le_mono_inv :
 forall p q r : nat, 1 < r -> power r p <= power r q -> p <= q.
Proof.
intros p q r H H0; case (Nat.le_gt_cases p q); auto; intros H1.
contradict H0; auto with arith.
apply Nat.lt_nge; apply power_lt_mono; auto with arith.
Qed.

Theorem power_id_lt : forall p q : nat, 0 < p -> 1 < q -> p < power q p.
Proof.
intros p q; elim p; simpl in |- *; auto with arith.
intros p1; case p1; simpl in |- *; auto with arith.
rewrite Nat.mul_comm; simpl in |- *; auto with arith.
intros n H H0 H1; apply Nat.le_lt_trans with (q * S n); auto with arith.
apply Nat.le_trans with (2 * S n); auto with arith.
simpl in |- *; auto with arith.
repeat (rewrite <- plus_n_Sm; simpl in |- *); auto with arith.
repeat rewrite (fun x => Nat.mul_comm x (S n));
 apply (fun m n p : nat => Nat.mul_le_mono_l p n m); 
 auto with arith.
Qed.

Theorem power_lt_mono_inv1 :
 forall p q r : nat, 0 < r -> power r p < power r q -> p < q.
Proof.
intros p q r Hr H; case (Nat.le_gt_cases q p); auto; intros H1.
contradict H; auto with arith.
apply Nat.le_ngt; apply power_le_mono; auto with arith.
Qed.

Theorem power_lt_mono_inv2 :
 forall p q r : nat, 0 < q -> power r p < power r q -> p < q.
Proof.
intros p q r H1 H2; apply power_lt_mono_inv1 with (r := r); auto.
generalize H1 H2; case r; simpl in |- *; auto with arith.
case q; simpl in |- *; auto with arith.
case p; simpl in |- *; auto with arith.
Qed.
