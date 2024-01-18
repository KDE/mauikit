package com.kde.maui.tools;
import android.content.res.Configuration;
import android.content.res.Resources ;
import android.content.Context;

public class ConfigActivity
{
    public static int systemStyle(Context context)
    {

        System.out.println("Getting system style preference");
        Configuration config = context.getResources().getConfiguration();

        switch (config.uiMode & Configuration.UI_MODE_NIGHT_MASK)
        {
            case Configuration.UI_MODE_NIGHT_YES:
            {
                System.out.println("DARK MODE PREFERRED");
                return 1;
                }
            case Configuration.UI_MODE_NIGHT_NO:
            {
                System.out.println("LIGHT MODE PREFERRED");
              return 0;
              }
        }

    return 0;
        }

}
