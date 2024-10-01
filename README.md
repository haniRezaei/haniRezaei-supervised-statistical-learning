# haniRezaei-supervised-statistical-learning
This project analyzes the South African Heart Disease dataset to predict coronary heart disease (CHD) based on various risk factors like age, tobacco use, cholesterol levels, and family history. Three different machine learning models are implemented: Logistic Regression, Naive Bayes, and k-Nearest Neighbors (kNN). The project also employs cross-validation to evaluate model performance.

* Data Visualization: A pairs plot is generated to visualize the relationships between different features and CHD.

* Logistic Regression: A full logistic regression model is fitted using all available features.
A reduced logistic regression model is fitted using a subset of significant predictors (tobacco, LDL, family history, type A personality, and age).

* 5-Fold Cross-Validation: The dataset is split into 5 folds to evaluate model performance. This approach reduces overfitting and provides more reliable estimates of accuracy.
Naive Bayes Classifier:

* Two versions are implemented: one using Gaussian density and another using kernel density estimation.
Both models are evaluated using cross-validation to compare their performance.

* k-Nearest Neighbors (kNN):
Cross-validation is used to select the optimal value of k.
The best-performing model is evaluated on a validation set.

**Performance Metrics:
Accuracy: The models are evaluated based on their accuracy in predicting whether a patient has CHD.
Sensitivity: The percentage of true positives correctly identified by the models.
Precision: The percentage of positive predictions that are actually correct.
This project provides a basic exploration of how different machine learning algorithms can be applied to medical datasets to predict health outcomes, helping to identify patterns and risk factors for heart disease.
