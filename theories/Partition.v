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
    Proof of Bertrand's conjecture: Partition.v
                                         Laurent.Thery@inria.fr (2002)
  *********************************************************************)

From Coq Require Import Wf_nat Arith ArithRing List.
From Bertrand Require Import Bertrand.

(*** All these theorems are in coq 8.16 *)
Lemma even_double n : Nat.Even n -> n = Nat.double (Nat.div2 n).
Proof.
intros [x ->]; rewrite Nat.div2_double; unfold Nat.double; ring.
Qed.

Lemma even_mul_l n m : Nat.Even n -> Nat.Even (n * m).
Proof.
intros [x ->]; exists (x * m); ring.
Qed.

Lemma odd_add_even_inv_r  n m : Nat.Odd (n + m) -> Nat.Odd n -> Nat.Even m.
Proof.
intros [x Hmn] [y Hn]; exists (x - y).
rewrite Nat.mul_sub_distr_l, <- Nat.sub_succ.
rewrite <- Nat.add_1_r, <- Hmn, <- Nat.add_1_r, <- Hn.
rewrite Nat.add_comm, Nat.add_sub; auto.
Qed.

Lemma odd_add_odd_inv_r n m :  Nat.Odd (n + m) -> Nat.Even n -> Nat.Odd m.
Proof.
destruct m as [|m].
rewrite Nat.add_0_r; intros; case (Nat.Even_Odd_False n); auto.
intros [x Hmn] [y Hn]; exists (x - y).
rewrite Nat.mul_sub_distr_l, <- Nat.sub_succ.
rewrite <- (Nat.add_1_r (2 * x)), <- Hmn, <- Hn.
rewrite <- (Nat.add_succ_comm n), (Nat.add_comm (S n)).
rewrite Nat.add_sub, Nat.add_1_r; auto.
Qed.

(***  *)

Theorem prime_2 : forall p : nat, prime p -> p = 2 \/ Nat.Odd p.
Proof.
intros p H.
case (Nat.Even_or_Odd p); auto; intros H1; left.
case H; intros H2 H3; apply H3; auto with arith.
exists (Nat.div2 p); auto with arith.
apply trans_equal with (Nat.double (Nat.div2 p)); auto with arith.
rewrite <- even_double; auto.
unfold Nat.double in |- *; ring.
Qed.

Theorem lt_mult_inv : forall a b c : nat, a * b < a * c -> b < c.
Proof.
intros a; case a.
intros b c H1; inversion H1.
intros a1 b c H; case (Nat.le_gt_cases c b); auto; intros H1.
absurd (S a1 * c <= S a1 * b); auto with arith.
Qed.

Fixpoint bertrand_fun_aux (n m : nat) {struct m} : nat :=
  match primeb n with
  | true => n
  | false => match m with
             | O => 0
             | S m1 => bertrand_fun_aux (S n) m1
             end
  end.

Theorem bertrand_fun_aux_correct :
 forall n m : nat,
 match bertrand_fun_aux n m with
 | O => forall p : nat, n <= p /\ p <= n + m -> ~ prime p
 | S p => n <= S p /\ S p <= n + m /\ prime (S p)
 end.
Proof.
intros n m; generalize n; elim m; simpl in |- *; auto; clear n m.
intros n; generalize (primeb_correct n); case (primeb n).
case n; simpl in |- *; auto with arith.
rewrite <- plus_n_O; intros H p (H1, H2); replace p with n;
 try apply Nat.le_antisymm; auto with arith.
intros m Rec n.
generalize (primeb_correct n); case (primeb n); auto with arith.
case n; simpl in |- *; auto with arith.
intros H; generalize (Rec (S n)); case (bertrand_fun_aux (S n) m);
 auto with arith.
intros H0 p (H1, H2).
case (proj1 (Nat.lt_eq_cases _ _) H1); auto with arith.
intros H3; apply H0; auto with arith.
split; auto with arith.
rewrite Nat.add_succ_comm; auto.
intros H3; rewrite <- H3; auto.
intros n1 (H1, (H2, H3)); split; auto with arith; split; auto with arith.
rewrite <- Nat.add_succ_comm; auto with arith.
Qed.

Definition bertrand_fun :
  forall n : nat, {p : nat | 1 < n -> n < p /\ p < 2 * n /\ prime p}.
intros n; exists (bertrand_fun_aux (S n) (pred (pred n))).
intros H1; generalize (bertrand_fun_aux_correct (S n) (pred (pred n))).
case (bertrand_fun_aux (S n) (pred (pred n))).
intros H2; case (Bertrand n); auto.
intros p (H3, (H4, H5)).
absurd (prime p); auto with arith.
apply H2; split; auto with arith.
rewrite Nat.add_succ_comm, Nat.succ_pred_pos; auto with arith.
apply Nat.lt_succ_r.
rewrite plus_n_Sm; rewrite (Nat.lt_succ_pred 0 n); auto with arith.
replace (n + n) with (2 * n); auto with arith; ring.
intros p (H3, (H4, H5)).
split; auto with arith.
split; auto with arith.
replace (2 * n) with (S (S n + pred (pred n))); auto with arith.
rewrite Nat.add_succ_comm; rewrite (Nat.lt_succ_pred 0 (pred n)); auto with arith.
rewrite plus_n_Sm; rewrite (Nat.lt_succ_pred 0 n); auto with arith; ring.
Defined.

Definition Partition :
  forall n : nat,
  {f : nat -> nat |
  forall m : nat,
  1 <= m /\ m <= 2 * n ->
  f m <> m /\ f (f m) = m /\ (1 <= f m /\ f m <= 2 * n) /\ prime (f m + m)}.
intros n; pattern n in |- *; apply lt_wf_rec; clear n; intros n.
case n.
intros H; exists (fun x : nat => x).
intros m; rewrite <- mult_n_O; intros (H1, H2);
 (absurd (1 <= m); auto; inversion H2); auto with arith.
clear n; intros n Rec.
case (bertrand_fun (2 * S n)); auto with arith.
intros p Hp.
case Hp;
 [ simpl in |- *; rewrite <- plus_n_Sm; auto with arith
 | intros Hp1 (Hp2, Hp3) ].
cut (Nat.Even (2 * S n)); 
  [ intros Hn | apply even_mul_l; exists 1; auto].
cut (Nat.Even (pred (p - 2 * S n))); [ intros Heven | idtac ].
cut (Nat.div2 (pred (p - 2 * S n)) < S n); [ intros H4 | idtac ].
case (Rec (Nat.div2 (pred (p - 2 * S n))) H4).
intros f1 Rf1.
exists
 (fun x : nat =>
  match le_lt_dec x (2 * S n) with
  | left _ =>
      match le_lt_dec (p - 2 * S n) x with
      | left _ => p - x
      | right _ => f1 x
      end
  | right _ => 0
  end).
case Hp; auto with arith.
simpl in |- *; rewrite <- plus_n_Sm; auto with arith.
intros H1 (H2, H3).
intros m1 (H5, H6).
cut (m1 <= p);
 [ intros Hm1 | apply Nat.le_trans with (1 := H6); auto with arith ].
split.
case (le_lt_dec m1 (2 * S n)); intros H7; auto with arith.
case (le_lt_dec (p - 2 * S n) m1); intros H8; auto with arith.
2: case (Rf1 m1); auto.
2: split; auto.
case (prime_2 p); auto; intros H9.
absurd (p <= 2 * S n); auto with arith; rewrite H9; auto with arith.
replace 2 with (2 * 1) at 1 by auto; auto with arith.
red in |- *; intros H; apply (Nat.Even_Odd_False  p); auto with arith.
replace p with (2 * m1).
apply even_mul_l; exists 1; auto.
simpl in |- *; pattern m1 at 1 in |- *; rewrite <- H.
rewrite <- plus_n_O.
rewrite Nat.sub_add; auto.
cut (forall x : nat, 2 * x = Nat.double x);
 [ intros tmp; rewrite tmp | idtac ].
rewrite <- even_double; auto with arith.
generalize H8; case (p - 2 * S n); simpl in |- *; auto with arith.
intros x; simpl in |- *; unfold Nat.double in |- *; auto with arith.
case (le_lt_dec m1 (2 * S n)); intros H7; auto with arith.
case (le_lt_dec (p - 2 * S n) m1); intros H8; auto with arith.
case (le_lt_dec (p - m1) (2 * S n)); intros H9; auto with arith.
case (le_lt_dec (p - 2 * S n) (p - m1)); intros H10; auto with arith.
split.
apply Nat.add_sub_eq_l.
rewrite Nat.sub_add; auto with arith.
rewrite Nat.sub_add; auto with arith.
split; auto.
split; auto.
apply Nat.le_add_le_sub_r.
rewrite Nat.add_1_l.
apply Nat.le_succ_l.
apply Nat.le_lt_trans with (2 := H1); auto with arith.
absurd (2 * S n < m1); auto with arith.
apply Nat.add_lt_mono_l with (p := p).
pattern p at 1 in |- *; rewrite <- (Nat.sub_add m1); auto with arith.
rewrite (Nat.add_comm _ m1).
pattern p at 2 in |- *; rewrite <- (Nat.sub_add (2 * S n)); auto with arith.
rewrite (Nat.add_comm (p - _) (2 * S n)).
replace (m1 + (p - m1) + 2 * S n) with (2 * S n + (p - m1) + m1);
 auto with arith; ring.
absurd (m1 < p - 2 * S n); auto with arith.
apply Nat.add_lt_mono_l  with (p := 2 * S n); auto with arith.
rewrite (Nat.add_comm _ (_ - _)), Nat.sub_add; auto with arith.
rewrite <- (Nat.sub_add m1 p); auto with arith.
case (Rf1 m1); auto with arith.
split; auto with arith.
cut (forall x : nat, 2 * x = Nat.double x);
 [ intros tmp; rewrite tmp | idtac ].
rewrite <- even_double; auto with arith.
generalize H8; case (p - 2 * S n); simpl in |- *; auto with arith.
intros x; simpl in |- *; unfold Nat.double in |- *; auto with arith.
intros H9 (H10, ((H11, H12), H13)).
case (le_lt_dec (f1 m1) (2 * S n)); auto with arith.
case (le_lt_dec (p - 2 * S n) (f1 m1)); auto with arith.
intros H14; absurd (2 * Nat.div2 (pred (p - 2 * S n)) < f1 m1); auto with arith.
cut (forall x : nat, 2 * x = Nat.double x);
 [ intros tmp; rewrite tmp | idtac ].
rewrite <- even_double; auto with arith.
generalize H14; case (p - 2 * S n); simpl in |- *; auto with arith.
intros x; simpl in |- *; unfold Nat.double in |- *; auto with arith.
intros H14; absurd (2 * Nat.div2 (pred (p - 2 * S n)) < f1 m1); auto with arith.
cut (forall x : nat, 2 * x = Nat.double x);
 [ intros tmp; rewrite tmp | idtac ].
rewrite <- even_double; auto with arith.
apply Nat.lt_trans with (2 := H14).
apply Nat.succ_lt_mono.
rewrite Nat.succ_pred_pos; auto with arith.
apply Nat.lt_succ_r; auto with arith.
apply (fun p n m : nat => Nat.add_le_mono_l n m p) with (p := 2 * S n).
rewrite Nat.add_comm, Nat.sub_add; auto with arith.
replace (2 * S n + 2 * S n) with (2 * (2 * S n)); auto with arith; ring.
apply Nat.add_lt_mono_l with (p := 2 * S n); auto with arith.
rewrite (Nat.add_comm _ (p - 2 * S n)), Nat.sub_add; auto with arith.
rewrite <- plus_n_O; auto.
intros x; simpl in |- *; unfold Nat.double in |- *; auto with arith.
absurd (2 * S n < m1); auto with arith.
apply lt_mult_inv with (a := 2); auto with arith.
cut (forall x : nat, 2 * x = Nat.double x);
 [ intros tmp; rewrite tmp | idtac ].
rewrite <- even_double; auto with arith.
apply Nat.succ_lt_mono.
rewrite Nat.succ_pred_pos; auto with arith.
apply Nat.lt_succ_r; auto with arith.
apply (fun p n m : nat => Nat.add_le_mono_l n m p) with (p := 2 * S n).
rewrite Nat.add_comm, Nat.sub_add; auto with arith.
replace (2 * S n + 2 * S n) with (2 * (2 * S n)); auto with arith; ring.
apply Nat.add_lt_mono_l with (p := 2 * S n); auto with arith.
rewrite (Nat.add_comm _ (p - 2 * S n)), Nat.sub_add; auto with arith.
rewrite <- plus_n_O; auto.
intros x; simpl in |- *; unfold Nat.double in |- *; auto with arith.
apply (odd_add_even_inv_r 1); auto with arith.
change (Nat.Odd (S (pred (p - 2 * S n)))) in |- *.
rewrite Nat.succ_pred_pos.
apply (odd_add_odd_inv_r (2 * S n)); auto.
rewrite Nat.add_comm, Nat.sub_add; auto with arith.
case (prime_2 p); auto.
intros H9.
absurd (p <= 2 * S n); auto with arith.
rewrite H9; case n; simpl in |- *; auto with arith.
apply lt_minus_O_lt; auto.
exists 0; auto.
Defined.

Fixpoint make_partition_aux (f : nat -> nat) (n : nat) {struct n} :
 list (nat * nat) :=
  match n with
  | O => nil (A:=nat * nat)
  | S n1 =>
      match le_lt_dec (f n) n with
      | left _ => make_partition_aux f n1
      | right _ => (n, f n) :: make_partition_aux f n1
      end
  end.

Theorem make_partition_aux_correct :
 forall (n : nat) (f : nat -> nat),
 (forall i j : nat,
  In (i, j) (make_partition_aux f n) -> 1 <= i /\ i <= n /\ i < j /\ j = f i) /\
 (forall i : nat,
  1 <= i /\ i <= n /\ i < f i -> In (i, f i) (make_partition_aux f n)).
Proof.
intros n f; elim n; simpl in |- *; auto.
split.
intros i j H; elim H.
intros i (H1, (H2, H3)); absurd (0 < i); auto with arith.
intros n1 (Rec, Rec1); case (le_lt_dec (f (S n1)) (S n1)); simpl in |- *;
 auto.
intros H; split.
intros i j H1; case (Rec i j); auto.
intros H2 (H3, H4); auto with arith.
intros i (H1, (H2, H3)).
case (le_lt_eq_dec _ _ H2); auto with arith.
intros H4; absurd (f i <= i); auto with arith; rewrite H4; auto with arith.
intros H; split.
intros i j [H1| H1]; auto.
injection H1.
intros H2 H3; rewrite <- H2; rewrite <- H3; auto with arith.
case (Rec i j); auto.
intros H2 (H3, H4); auto with arith.
intros i (H1, (H2, H3)).
case (le_lt_eq_dec _ _ H2); auto with arith.
Qed.

Definition make_partition : nat -> list (nat * nat).
intros n; case (Partition n).
intros f1 Hf1.
exact (make_partition_aux f1 (2 * n)).
Defined.

(** make_partition:
    Create a partition of  1..2n in pairs such that the sum of each
    pair is a prime number 
*)
Theorem make_partition_correct :
 forall n : nat,
 (forall i j k l : nat,
  In (i, j) (make_partition n) /\ In (k, l) (make_partition n) ->
  (i = k <-> j = l) /\ i <> l /\ j <> k) /\
 (forall i : nat,
  1 <= i /\ i <= 2 * n ->
  exists j : nat,
    In (i, j) (make_partition n) \/ In (j, i) (make_partition n)) /\
 (forall i j : nat,
  In (i, j) (make_partition n) ->
  (1 <= i /\ i <= 2 * n) /\ 1 <= j /\ j <= 2 * n) /\
 (forall i j : nat, In (i, j) (make_partition n) -> prime (i + j)).
Proof.
intros n; unfold make_partition in |- *.
case (Partition n).
intros f Hf; split.
intros i j k l (H1, H2).
case (make_partition_aux_correct (2 * n) f); intros HR1 HR2.
case (HR1 _ _ H1); intros H3 (H4, (H5, H6)).
case (HR1 _ _ H2); intros H7 (H8, (H9, H10)).
case (Hf i); auto with arith; intros H11 (H12, ((H13, H14), H15)).
case (Hf k); auto with arith; intros H16 (H17, ((H18, H19), H20)).
split; split.
intros H21; apply trans_equal with (1 := H6);
 apply trans_equal with (2 := sym_equal H10); apply f_equal with (f := f);
 auto with arith.
intros H21; apply trans_equal with (1 := sym_equal H12);
 apply trans_equal with (2 := H17); apply f_equal with (f := f);
 auto with arith; apply trans_equal with (1 := sym_equal H6);
 apply trans_equal with (1 := H21); auto.
red in |- *; intros H21; absurd (j <= i); auto with arith.
rewrite H6; rewrite H21; rewrite H10; rewrite H17; rewrite <- H10;
 auto with arith.
red in |- *; intros H21; absurd (l <= k); auto with arith.
rewrite H10; rewrite <- H21; rewrite H6; rewrite H12; rewrite <- H6;
 auto with arith.
split.
intros i (H1, H2); exists (f i).
case (make_partition_aux_correct (2 * n) f); intros HR1 HR2.
case (Nat.le_gt_cases i (f i)); intros H3.
case (le_lt_eq_dec _ _ H3); intros H4; auto with arith.
left; apply HR2; repeat (split; auto with arith).
case (Hf i); auto with arith.
intros H5; case H5; auto.
right; case (Hf i); auto with arith.
intros H4 (H5, ((H6, H7), H8)).
pattern i at 2 in |- *; rewrite <- H5.
apply HR2; repeat (split; auto with arith).
rewrite H5; auto.
split.
intros i j H1.
case (make_partition_aux_correct (2 * n) f); intros HR1 HR2.
case (HR1 _ _ H1).
intros H2 (H3, (H4, H5)); split; auto.
rewrite H5; case (Hf i); auto with arith.
intros H6 (H7, ((H8, H9), H10)); auto.
intros i j H1.
case (make_partition_aux_correct (2 * n) f); intros HR1 HR2.
case (HR1 _ _ H1).
intros H2 (H3, (H4, H5)); auto.
rewrite H5; auto.
case (Hf i); auto with arith.
rewrite (Nat.add_comm i); intuition.
Qed.
