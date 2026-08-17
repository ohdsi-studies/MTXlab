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
24843, 24844, 24845, 24846, 24847, 24848, 24849, 24850, 24851,

    # Psoriasis
24852, 24853, 24854, 24886, 24887, 24888, 24889, 24890, 24891,

    # RA
24892, 24893, 24894, 24895, 24896, 24897, 24898, 24899, 24900,

    #PsA
24901, 24902, 24903, 24904, 24905, 24906, 24907, 24908, 24909,

    #Crohn's 
24910, 24911, 24912, 24913, 24914, 24915, 24916, 24917, 24918,

    #Ulcerative colitis
24919, 24920, 24921, 24922, 24923, 24924, 24925, 24926, 24927,

    #Overall
24769, 24770, 24840, 24771, 24841, 24772, 24842, 24773, 24774

  ),
  outcomeId = rep(
    c(
      24180, 24181, 24190, 24191,
      24185, 24186, 24187, 24188,
      24183
    ),
    7
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
    7
  )
)
