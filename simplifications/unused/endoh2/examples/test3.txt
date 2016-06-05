atoms:
 - Order of preprocessor steps. Which happens first? Macro evaluation or comment stripping?
   - Is there a case where it matters? It matters because #define/*asfd*/ wouldn't compile if comments weren't removed first
 -
