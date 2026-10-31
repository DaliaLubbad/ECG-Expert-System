% Soft Computing - Assignment 1
% Educational ECG rule-based expert system (36 reference patterns)
% Each feature is represented by feature(CaseId, FeatureName, Value).
% Missing features are UNKNOWN, not assumed normal.

:- dynamic feature/3.

% rule(Class, RequiredFeatures). A match requires ALL listed features.
% These rules are educational pattern descriptions, not clinical diagnoses.
rule(normal_sinus_rhythm, [rhythm-regular, sinus_p-yes, heart_rate_band-normal]).
rule(sinus_bradycardia, [rhythm-regular, sinus_p-yes, heart_rate_band-low]).
rule(sinus_tachycardia, [rhythm-regular, sinus_p-yes, heart_rate_band-high]).
rule(atrial_fibrillation, [rhythm-irregularly_irregular, distinct_p-no]).
rule(atrial_flutter, [flutter_waves-yes]).
rule(supraventricular_tachycardia, [rhythm-regular, heart_rate_band-very_high, qrs_width-narrow, distinct_p-not_visible]).
rule(ventricular_tachycardia, [rhythm-regular, heart_rate_band-high, qrs_width-wide, ventricular_origin_suspected-yes]).
rule(ventricular_fibrillation, [organized_qrs-no, chaotic_waveform-yes]).
rule(premature_atrial_contraction, [premature_beat-yes, premature_p-abnormal, premature_qrs-narrow]).
rule(premature_ventricular_contraction, [premature_beat-yes, premature_qrs-wide, compensatory_pause-yes]).
rule(first_degree_av_block, [pr_interval-prolonged, p_to_qrs_relation-one_to_one]).
rule(mobitz_i_av_block, [pr_progression-progressive_lengthening, dropped_qrs-yes]).
rule(mobitz_ii_av_block, [pr_progression-constant, dropped_qrs-yes]).
rule(third_degree_av_block, [av_dissociation-yes]).
rule(right_bundle_branch_block, [qrs_width-wide, v1_pattern-rsr_prime]).
rule(left_bundle_branch_block, [qrs_width-wide, v1_pattern-deep_negative, lateral_r-broad]).
rule(left_anterior_fascicular_block, [axis-left_deviation, inferior_leads-rs, lateral_leads-qr]).
rule(wolff_parkinson_white_pattern, [pr_interval-short, delta_wave-yes, qrs_width-wide]).
rule(long_qt, [qtc_category-prolonged]).
rule(short_qt, [qtc_category-short]).
rule(brugada_pattern, [right_precordial_st-coved_elevation]).
rule(stemi_pattern, [contiguous_leads_st-elevated, st_elevation_criteria-met]).
rule(ischemic_st_t_pattern, [st_depression_or_t_inversion-yes]).
rule(prior_mi_pattern, [pathological_q_waves-yes]).
rule(pericarditis_pattern, [st_elevation_distribution-diffuse, pr_depression-yes]).
rule(myocarditis_nonspecific_pattern, [nonspecific_st_t_changes-yes, clinical_context-myocarditis_suspected]).
rule(left_ventricular_hypertrophy_pattern, [lvh_voltage_criteria-met, strain_pattern-yes]).
rule(right_ventricular_hypertrophy_pattern, [axis-right_deviation, v1_r_wave-tall, rvh_supporting_criteria-met]).
rule(left_atrial_enlargement_pattern, [p_wave-broad_notched]).
rule(right_atrial_enlargement_pattern, [p_wave-tall_peaked]).
rule(hyperkalemia_pattern, [t_wave-tall_peaked, clinical_context-hyperkalemia_suspected]).
rule(hypokalemia_pattern, [u_wave-prominent, t_wave-flattened, st_segment-depressed]).
rule(hypercalcemia_pattern, [qt_interval-short]).
rule(hypocalcemia_pattern, [qt_interval-prolonged]).
rule(pulmonary_embolism_suggestive_pattern, [s1q3t3-yes, sinus_tachycardia-yes]).
rule(hypothermia_pattern, [osborn_wave-yes, heart_rate_band-low]).

% A rule succeeds only if all of its required facts are explicitly supplied.
all_features_present(_, []).
all_features_present(Case, [Name-Value|Rest]) :-
    feature(Case, Name, Value),
    all_features_present(Case, Rest).

% All possible matches; overlapping patterns are intentionally allowed.
diagnosis(Case, Condition) :-
    rule(Condition, Requirements),
    all_features_present(Case, Requirements).

% Return a sorted list, empty when no rule matches.
diagnose_all(Case, Conditions) :-
    findall(Condition, diagnosis(Case, Condition), Found),
    sort(Found, Conditions).

% Explain the exact feature requirements of a matched rule.
explain(Case, Condition, Requirements) :-
    rule(Condition, Requirements),
    all_features_present(Case, Requirements).

% Four DEMO inputs, constructed from the educational descriptions.
% These are NOT independent test recordings or extracted image measurements.
feature(demo_normal, rhythm, regular).
feature(demo_normal, sinus_p, yes).
feature(demo_normal, heart_rate_band, normal).

feature(demo_brady, rhythm, regular).
feature(demo_brady, sinus_p, yes).
feature(demo_brady, heart_rate_band, low).

feature(demo_tachy, rhythm, regular).
feature(demo_tachy, sinus_p, yes).
feature(demo_tachy, heart_rate_band, high).

feature(demo_af, rhythm, irregularly_irregular).
feature(demo_af, distinct_p, no).

% Use this to add an input without editing the source file:
% assertz(feature(my_case, rhythm, irregularly_irregular)).
% assertz(feature(my_case, distinct_p, no)).
% diagnose_all(my_case, Results).

% Test every rule using its own required features.
test_all_rules :-
    findall(Condition, rule(Condition, _), Conditions),
    length(Conditions, Total),
    format('Total rules: ~w~n', [Total]),
    forall(
        rule(Condition, Requirements),
        (
            forall(
                member(Name-Value, Requirements),
                assertz(feature(test_case, Name, Value))
            ),
            ( diagnosis(test_case, Condition)
              -> format('PASS: ~w~n', [Condition])
              ;  format('FAIL: ~w~n', [Condition])
            ),
            retractall(feature(test_case, _, _))
        )
    ).
