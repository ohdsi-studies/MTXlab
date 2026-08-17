labDefinitions <- data.frame(
  condition = c(
    rep("Atopic dermatitis", 9),
    rep("Psoriasis", 9),
    rep("Rheumatoid arthritis", 9)
  ),
  targetId = c(
    # AD
    24843, 24844, 24845, 24846, 24847, 24848, 24849, 24850, 24851,

    # Psoriasis
    25843, 25844, 25845, 25846, 25847, 25848, 25849, 25850, 25851,

    # RA
    26843, 26844, 26845, 26846, 26847, 26848, 26849, 26850, 26851
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
      "ALT (150 - 1000 U/L)",
      "eGFR (10 - 45 mL/min/1.73m²)",
      "Creatinine EU (125 - 500 μmol/L)",
      "Creatinine USA (125 - 500 μmol/L)",
      "Hemoglobin EU (2 - 6 mmol/L)",
      "Hemoglobin USA (2 - 6 mmol/L)",
      "Leucocytes EU (0.5 - 2.0 x 10⁹/L)",
      "Leucocytes USA (0.5 - 2.0 x 10⁹/L)",
      "Platelets (10 - 100 x 10⁹/L)"
    ),
    3
  )
)
