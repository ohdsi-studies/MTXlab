.KMDefinitions <- data.frame(
  condition = c(
    rep("Atopic dermatitis", 9),
    rep("Psoriasis", 9),
    rep("Rheumatoid arthritis", 9),
    rep("Psoriatic arthritis", 9),
    rep("Crohn's Disease", 9),
    rep("Ulcerative Colitis", 9),
    rep("Overall", 9)
  ),
  targetId = c(
    # AD

    # Psoriasis

    # RA

    #PsA

    #Crohn's 

    #Ulcerative colitis

    #Overall
    
  ),
  outcomeId = rep(
    c(
      24180, 24181, 24190, 24191,
      24185, 24186, 24187, 24188,
      24183
    ),
    3
  ),
  laboratoryValue = rep(
    c(
      "ALT (150 - 1000)",
      "eGFR (10 - 45)",
      "Creatinine EU (125 - 500)",
      "Creatinine USA (125 - 500)",
      "Hemoglobin EU (2 - 6)",
      "Hemoglobin USA (2 - 6)",
      "Leucocytes EU (0.5 - 2.0)",
      "Leucocytes USA (0.5 - 2.0)",
      "Platelets (10 - 100)"
    ),
    3
  )
)
