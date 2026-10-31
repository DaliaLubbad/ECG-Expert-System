
# ECG Classification Using Prolog

## About the Project

This project was developed for the Soft Computing course.

The aim is to use Prolog to identify different ECG patterns based on their characteristics.

## How It Works

The system uses facts and rules.

Each rule describes the ECG features associated with a specific condition. When the user provides these features, Prolog checks the rules and returns the matching conditions.

I included 36 ECG patterns in the knowledge base.

## Tools

- SWI-Prolog
- VS Code

## Running the Code

1. Open the `knowledge_base.pl` file in SWI-Prolog.
2. Try one of these queries:

    diagnose_all(demo_normal, Results).
    diagnose_all(demo_af, Results).

3. To test all rules, run:

    test_all_rules.

## Results

The system was tested using example ECG features. All 36 rules passed the rule-matching test.

## Note

The current version uses ECG features as input rather than reading ECG images directly.

## Example

For example, atrial fibrillation is represented by this rule:

    rule(atrial_fibrillation,
         [rhythm-irregularly_irregular, distinct_p-no]).

This means that the system looks for an irregularly irregular rhythm and the absence of distinct P waves.

The following query can be used to test this case:

    diagnose_all(demo_af, Results).

Output:

    Results = [atrial_fibrillation].

## Rule Matching

The program checks the ECG features against the conditions defined in the knowledge base.

If all the required features of a rule are present, that condition is returned as a possible match. More than one condition can be returned if multiple rules match.
