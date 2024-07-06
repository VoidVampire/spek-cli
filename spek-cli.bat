@echo off
setlocal enabledelayedexpansion

set "spekPath=C:\Program Files\Spek\spek.exe"
set "nircmdPath=C:\nircmd-x64\nircmd.exe"
set "magickPath=C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe"

if not exist "%spekPath%" (
    echo Spek executable not found at "%spekPath%".
    exit /b 1
)

if not exist "%magickPath%" (
    echo Magick executable not found at "%magickPath%".
    exit /b 1
)

if "%~1"=="" (
    echo This is a project to create screenshot of Spek's spectograms.
    echo Usage: spek-cli [options] filename_or_directory
    echo Options:
    echo -save         Save a screenshot in the directory of the file
    echo -clipboard    Copy a screenshot to the clipboard
    exit /b 0
)

set "option=%~1"
set "input=%~2"


if "%option%"=="-save" (
    if exist "%input%" (
        if exist "%input%\" (
            set /p "num_columns=Enter the number of columns: "
            set "count=1"
            set "row=1"
            for %%f in ("%input%\*.*") do (
                start "" "%spekPath%" "%%f"
                "%nircmdPath%" win activate title "Spek"
                timeout /t 2 /nobreak > nul
                "%nircmdPath%" savescreenshotwin "%input%\!count!.png"
                timeout /t 2 /nobreak > nul
                "%nircmdPath%" killprocess spek.exe
                timeout /t 2 /nobreak > nul
                set /a "count+=1"
            )

            set /a "count-=1"

            @REM Calculate number of rows
            set /a "num_rows=(count + num_columns - 1) / num_columns"

            echo Debug: Number of rows calculated is !num_rows!

            for /l %%r in (1,1,!num_rows!) do (
                set "append_args="
                for /l %%c in (1,1,!num_columns!) do (
                    set /a "index=(%%r - 1) * num_columns + %%c"
                    if !index! leq !count! (
                        set "append_args=!append_args! "%input%\!index!.png""
                    )
                )
                @REM echo Debug: Combining row %%r with images !append_args!
                call "%magickPath%" !append_args! +append "%input%\row%%r.png"
                @REM echo Debug: Combined row %%r saved as "%input%\row%%r.png"
            )

            @REM Combine rows into final output image
            set "append_args="
            for /l %%r in (1,1,!num_rows!) do (
                set "append_args=!append_args! "%input%\row%%r.png""
            )
            @REM echo Debug: Combining all rows into final image !append_args!
            call "%magickPath%" !append_args! -append "%input%\final.png"

            @REM echo Debug: Deleting temporary files
            for /l %%i in (1,1,!count!) do (
                del "%input%\%%i.png"
            )

            for /l %%r in (1,1,!num_rows!) do (
                del "%input%\row%%r.png"
            )

            echo Screenshots combined into %input%\final.png
        ) else (
            start "" "%spekPath%" "%input%"
            timeout /t 2 /nobreak > nul
            for %%F in ("%input%") do (
                set "filename=%%~nF"
            )
            echo 
            "%nircmdPath%" savescreenshotwin "!filename!.png"
            "%nircmdPath%" killprocess spek.exe
            if not errorlevel 1 (
                echo Screenshot saved as "!filename!.png".
            ) else (
                echo Failed to capture screenshot.
            )
        )
        exit /b 0
    ) else (
        echo File or directory not found: "%input%"
        exit /b 1
    )
)

if "%option%"=="-clipboard" (
    if exist "%input%" (
        if exist "%input%\" (
            set /p "num_columns=Enter the number of columns: "
            set "count=1"
            set "row=1"
            for %%f in ("%input%\*.*") do (
                start "" "%spekPath%" "%%f"
                "%nircmdPath%" win activate title "Spek"
                timeout /t 2 /nobreak > nul
                "%nircmdPath%" savescreenshotwin "%input%\!count!.png"
                timeout /t 2 /nobreak > nul
                "%nircmdPath%" killprocess spek.exe
                timeout /t 2 /nobreak > nul
                set /a "count+=1"
            )

            set /a "count-=1"

            @REM Calculate number of rows
            set /a "num_rows=(count + num_columns - 1) / num_columns"

            echo Debug: Number of rows calculated is !num_rows!

            for /l %%r in (1,1,!num_rows!) do (
                set "append_args="
                for /l %%c in (1,1,!num_columns!) do (
                    set /a "index=(%%r - 1) * num_columns + %%c"
                    if !index! leq !count! (
                        set "append_args=!append_args! "%input%\!index!.png""
                    )
                )
                @REM echo Debug: Combining row %%r with images !append_args!
                call "%magickPath%" !append_args! +append "%input%\row%%r.png"
                @REM echo Debug: Combined row %%r saved as "%input%\row%%r.png"
            )

            @REM Combine rows into final output image
            set "append_args="
            for /l %%r in (1,1,!num_rows!) do (
                set "append_args=!append_args! "%input%\row%%r.png""
            )
            @REM echo Debug: Combining all rows into final image !append_args!
            call "%magickPath%" !append_args! -append "%input%\final.png"
            timeout /t 1 /nobreak > nul
            "%nircmdPath%" clipboard copyimage "%input%\final.png"

            @REM echo Debug: Deleting temporary files
            for /l %%i in (1,1,!count!) do (
                del "%input%\%%i.png"
            )

            for /l %%r in (1,1,!num_rows!) do (
                del "%input%\row%%r.png"
            )

            del "%input%\final.png"

            echo Screenshots combined and saved in clipboard
        ) else (
            @REM Copy screenshot to clipboard
            start "" "%spekPath%" "%input%"
            timeout /t 2 /nobreak > nul
            "%nircmdPath%" savescreenshotwin *clipboard*
            "%nircmdPath%" killprocess spek.exe
            if not errorlevel 1 (
                echo Screenshot copied to clipboard.
            ) else (
                echo Failed to capture screenshot.
            )
        )
        exit /b 0
    ) else (
        echo File or directory not found: "%input%"
        exit /b 1
    )
)

if exist "%~1\" (
    echo Directory detected.
    for %%f in ("%~1\*.*") do (
        start "" "%spekPath%" "%%f"
    )
    exit /b 0
)

if exist "%~1" (
    start "" "%spekPath%" "%~1"
    exit /b 0
) else (
    echo File or directory not found: "%~1"
    exit /b 1
)

endlocal
