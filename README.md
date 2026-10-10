# CensusLens: Demographic Intelligence & Resource Demand Suite

A computational mathematics and demographic intelligence application built for **MATLAB R2024** on Windows, analyzing the **2011 Census of India** across all **640 district administrative units**.

---

## Quick Start (For Beginners)

Launch the full interactive application with a single command in MATLAB:

```matlab
% In the MATLAB Command Window:
main
```

Or execute the launcher directly:
```matlab
launchCensusLensApp
```

To run the automated validation and test suite:
```matlab
addpath("src");
validate_data;  % Runs comprehensive geographic and data integrity checks
run_tests;      % Executes 10 automated test suites across all modules
```

---

## Project Architecture & Directory Structure

```text
CensusLens/
│
├── main.m                           # Primary entry point (launches dashboard)
├── launchCensusLensApp.m            # Application launcher function
├── CensusLensApp.mlapp              # Preserved MATLAB App Designer archive
├── README.md                        # Documentation and user guide
│
├── src/                             # Core algorithms and UI components
│   ├── CensusLensDashboard.m        # Standalone programmatic 9-tab MATLAB UI
│   ├── CensusLensAppCallbacks.m     # Modular callbacks for App Designer (Option 1)
│   ├── load_project_data.m          # Centralized data loading & caching engine
│   ├── get_geographic_metadata.m    # State mapping & unique composite key resolution
│   ├── preprocess_data.m            # Raw census filtering (Level=DISTRICT, TRU=Total)
│   ├── feature_engineering.m        # 6 core demographic rates computation
│   ├── standardize_data.m           # Z-score standardization function
│   ├── run_standardization.m        # Standardization pipeline runner
│   ├── manual_pca.m                 # Covariance PCA via eigendecomposition
│   ├── demographic_pca.m            # PCA on 6 standardized demographic features
│   ├── manual_svd.m                 # Economy SVD & PCA-SVD equivalence verification
│   ├── adaptive_pca.m               # Batch-wise full-refit PCA stability simulation
│   ├── run_clustering.m             # K-means clustering (k=3) & silhouette scoring
│   ├── analyze_clusters.m           # Demographic profiling of the 3-cluster partition
│   ├── resource_demand.m            # Early-childhood demographic proxy estimation
│   ├── calculate_forecast.m         # Parameterized compound forecasting function
│   ├── run_forecasting.m            # Baseline 5-year scenario forecasting script
│   ├── validate_data.m              # Comprehensive data validation suite
│   ├── run_tests.m                  # 10-point automated test verification suite
│   └── run_all_analyses.m           # Master sequential pipeline runner
│
├── data/
│   ├── raw/
│   │   └── 2011_Census.xlsx         # Primary Census Abstract (PCA) 2011
│   └── processed/
│       ├── census_processed.mat     # Cleaned district totals (640x8)
│       ├── demographic_features.mat # Demographic indicator matrix (640x6)
│       ├── census_standardized.mat  # Z-score standardized census features
│       └── demographic_standardized.mat # Standardized demographic indicators
│
├── results/
│   ├── pca/
│   │   ├── pca_results.mat          # Covariance PCA on census features
│   │   └── demographic_pca.mat      # Demographic PCA results (k95, loadings)
│   ├── svd/
│   │   └── svd_results.mat          # Singular values, SVD eigenvalues, reconstruction error
│   ├── adaptive/
│   │   └── adaptive_pca_results.mat # Cumulative batch PCA stability results
│   ├── clustering/
│   │   ├── cluster_results.mat      # K-means labels (k=3) and silhouette scores
│   │   ├── cluster_profiles.mat     # Cluster demographic centroids & sizes
│   │   └── cluster_profiles.csv     # Exported CSV of cluster profiles
│   └── forecasting/
│       ├── forecast_results.mat     # 5-year compound projections (2.0% baseline)
│       ├── forecast_results.csv     # Exported CSV of 640 district projections
│       └── resource_demand.mat      # Early childhood demand proxy register
│
└── docs/
    └── APP_DESIGNER_INTEGRATION.md  # Step-by-step App Designer integration guide
```

---

## Application Sections (Phase 3)

The dashboard comprises 9 structured analytical tabs:

1. **Overview**: Total population (1.21B), child cohort (164.5M), average child share (13.59%), national literacy (73.0%), top 10 most populous districts, and complete searchable table of all 640 districts.
2. **Demographics**: Evaluates 6 key demographic dimensions (Child Share, Literacy Proportion, SC Share, ST Share, Worker Ratio, Main Worker Ratio). Interactive district dropdown with comparison against national averages or other districts.
3. **PCA Analysis**: Scree plot of eigenvalues, individual and cumulative explained variance, $k_{95}$ component threshold, 2D projection scatter plot, and eigenvector loadings table.
4. **SVD Analysis**: Singular values $\sigma_i$, numerical validation proving $\lambda_i = \sigma_i^2 / (m-1)$, and relative Frobenius reconstruction error decay across truncation ranks $k=1 \dots n$.
5. **Adaptive PCA**: Displays cumulative batch simulation across $N \in [100, 200, \dots, 640]$. Rigorously distinguishes batch-wise full-refit PCA from genuine $O(nk)$ incremental PCA.
6. **District Clusters**: 3-cluster partition:
   - **Cluster 1 (125 Districts)**: High Tribal (ST) share (~66.3%), rural/agrarian workforce.
   - **Cluster 2 (207 Districts)**: High Child Share (~16.5%), lower literacy, young demographic dependency.
   - **Cluster 3 (308 Districts)**: High Literacy (~69.6%), lower child dependency, higher formal employment.
7. **Resource Planning**: Early-childhood cohort scale ($P_{0-6}$) and demographic concentration. Labeled strictly as an illustrative demographic proxy, not an audited facility deficit.
8. **Forecasting**: 5-year geometric sensitivity scenario ($P_t = P_0 (1+r)^t$). Interactive annual growth rate spinner (-3.0% to +5.0%, default 2.0%) with real-time recalculation of trajectories. Labeled as a sensitivity simulation, not an actuarial projection.
9. **Mathematical Summary**: Full mathematical dossier and quantitative benchmark register.

---

## Data Integrity & Duplicate District Resolution (Phase 5)

In India's Census 2011, several districts across different states share identical names:
- **Hamirpur**: Himachal Pradesh (Pop: 454k, Children: 48.5k) vs. Uttar Pradesh (Pop: 1.1M, Children: 154.4k)
- **Aurangabad**: Bihar (Pop: 2.5M) vs. Maharashtra (Pop: 3.7M)
- **Bilaspur**: Himachal Pradesh (Pop: 382k) vs. Chhattisgarh (Pop: 2.6M)
- **Pratapgarh**: Rajasthan (Pop: 868k) vs. Uttar Pradesh (Pop: 3.2M)
- **Bijapur**: Chhattisgarh (Pop: 255k) vs. Karnataka (Pop: 2.1M)

**Resolution**: CensusLens automatically generates unique composite keys: `DistrictName [StateName]`. This prevents cross-state selection collisions while preserving original census columns.

---

## Toolboxes & Compatibility

- **Required**: Base MATLAB R2024a or R2024b (no mandatory toolboxes).
- **Optional**: Statistics and Machine Learning Toolbox (used for `silhouette` if available; falls back gracefully to internal computation).
