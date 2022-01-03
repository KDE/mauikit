package com.kde.maui.tools;
import android.content.res.Configuration;

import org.qtproject.qt5.android.bindings.QtActivity;

public class ConfigActivity extends QtActivity
{

    private static native void darkModeEnabledChangedJNI();

@Override
public void onConfigurationChanged(Configuration newConfig) {
    super.onConfigurationChanged(newConfig);
    ConfigActivity.darkModeEnabledChangedJNI();
}

public boolean darkModeEnabled() {
    return (getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES;
}
}
