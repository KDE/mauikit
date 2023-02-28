package com.kde.maui.tools;
import android.content.res.Configuration;
import android.content.res.Resources ;
import android.content.Context;

public class ConfigActivity
{


    public static int systemStyle(Context context)
    {
        Configuration config = context.getResources().getConfiguration();

        switch (config.uiMode & Configuration.UI_MODE_NIGHT_MASK)
        {
            case Configuration.UI_MODE_NIGHT_YES:
                return 1;
            case Configuration.UI_MODE_NIGHT_NO:
              return 0;
        }

    return 0;
        }

}
