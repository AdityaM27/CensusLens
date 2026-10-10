# CensusLens: App Designer Integration Guide (Option 1)

This guide provides instructions for integrating the full analytical suite into the existing `CensusLensApp.mlapp` file using MATLAB App Designer in MATLAB R2024.

---

## Why Option 1 Requires MATLAB App Designer

MATLAB `.mlapp` files are binary ZIP packages containing compiled XML schemas, metadata, and M-code. Directly modifying `.mlapp` files outside MATLAB App Designer risks file corruption. To ensure 100% stability, you have two approaches:

1. **Recommended (Option 2 - Turnkey)**: Run the programmatic dashboard directly:
   ```matlab
   main
   % or
   launchCensusLensApp
   ```
   This immediately opens the complete 9-tab dashboard without requiring any App Designer editing.

2. **App Designer Integration (Option 1)**: If you wish to extend the original `CensusLensApp.mlapp` visually in App Designer, follow the steps below.

---

## Step-by-Step Integration in MATLAB App Designer

### Step 1: Open the App
In the MATLAB Command Window, navigate to your CensusLens directory and type:
```matlab
appdesigner CensusLensApp.mlapp
```

### Step 2: Add Component Tabs (Design View)
In the Component Browser, select the `TabGroup` and add tabs corresponding to the desired sections:
- `Overview`
- `Demographics`
- `PCA Analysis`
- `SVD Analysis`
- `Adaptive PCA`
- `Clustering`
- `Resource Planning`
- `Forecasting`
- `Mathematical Summary`

### Step 3: Add Private Property for Data (Code View)
Switch to **Code View** (top-right of App Designer). Under `properties (Access = private)`, add:
```matlab
properties (Access = private)
    Data struct  % Holds centralized project datasets
end
```

### Step 4: Add Startup Callback
In Code View, right-click on the app root in the Component Browser, select **Callbacks > Add StartupFcn callback**, and insert:
```matlab
% Code that executes after component creation
function startupFcn(app)
    addpath("src");
    app.Data = load_project_data();
    CensusLensAppCallbacks.populateOverview(app);
end
```

### Step 5: Wire Interactive Callbacks
Whenever you add a control (e.g., `DistrictDropDown` or `GrowthRateSpinner`), add a callback that delegates to `CensusLensAppCallbacks`:

- **For District Dropdown**:
  ```matlab
  function DistrictDropDownValueChanged(app, event)
      CensusLensAppCallbacks.updateDistrictComparison(app);
  end
  ```

- **For Growth Rate Spinner**:
  ```matlab
  function GrowthRateSpinnerValueChanged(app, event)
      CensusLensAppCallbacks.updateForecastScenario(app);
  end
  ```

### Step 6: Save and Run
Click **Save** (Ctrl+S) in App Designer, then click the green **Run** button (F5).
