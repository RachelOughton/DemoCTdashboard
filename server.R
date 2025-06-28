### Part I

# Useful page about shiny uploads and downloads:
# https://mastering-shiny.org/action-transfer.html#uploading-data

function(input, output, session) {
  ### Function to generate participant data 
  ### should only depend on input$n_per_arm
  thedata <- reactive({
    set.seed(92220)
    validate(
      need(is.integer(input$n_per_arm), "Please enter an integer value")
    )
    
    n_total = 2*input$n_per_arm
    ID = 1:n_total
    sex = as.factor(sample(c("M", "F"), size = n_total, replace = T, prob = c(0.45,0.55)))
    age = runif(n=n_total, min=50, max=65)
    baseline_int = 100 + 0.25*(age-50) + 10*(sex == "F")
    baseline = sapply(
      1:n_total,
      function(i){
        rnorm(1, mean=baseline_int[i], sd=5)
      }
    )
    BMI = rnorm(n=n_total, mean = 27, sd = 4)
 #   hist1 = as.factor(sample(c("Y", "N"), size = n_total, replace = T, prob = c(0.1,0.9)))
    df_part =  data.frame(ID = ID, sex=sex, age=age, baseline = baseline, BMI=BMI)
    df_part
  })
  

  ## This displays the participant data  
  output$dto <- renderTable({
    req(input$n_per_arm)
    
#    df_part <- data_missing()    
    df_part <- thedata()
    if(input$disp_p1 == "head") {
      return(head(df_part))
    }
    else {
      return(df_part)
    }
    
  })
  
  ## Download the participant data  
  output$download <- downloadHandler(
    filename = function(){"participant_data.csv"}, 
    content = function(fname){
      write.csv(thedata(), fname, quote=F, row.names=F)
    }
  )
  ## output$contents displays the uploaded file
  output$contents <- renderTable({

    req(input$file1)
    df_alloc <- read.csv(input$file1$datapath,
                   header = T,
                   sep = input$sep,
                   quote = "")
    if(is.character(df_alloc$arm)){
      df_alloc$arm = as.factor(df_alloc$arm)
    }

    if(is.character(df_alloc$sex)){
      df_alloc$sex = as.factor(df_alloc$sex)
    }
    names_upload = names(df_alloc)
    names_req = c("ID", "sex", "age", "baseline", "BMI", "arm")
    validate(
      need(
        identical(names_upload, names_req),
        sprintf(
          "The column names should be %s but yours are %s", 
          paste(names_req, collapse = ", " ), 
          paste(names_upload, collapse = ", "))
      )
    )
    
    if(input$disp == "head") {
      return(head(df_alloc))
    } else {
      return(df_alloc)
    }
    
  })
  
  ## Running the trial and downloading results
  ## Can I just put this here?
  ## DON'T USE input$n_per_arm BECAUSE IT WILL BE SET TO DEFAULT 1


  res_data <- reactive({
    #### There needs to be a bit more uncertainty I think.
    run_trial = function(
      df_alloc = df_alloc,
      coef_baseline =0.96,
      sd_coef_baseline = 0.07,
      coef_arm=-0.27,
      coef_sex=0,
      coef_BMI = -0.35,
      sd_coef_BMI = 0.01,
      coef_armsex=0.05,
      coef_armage=0,
      coef_norm=1,
      coef_unif=0,
      coef_cat=0.75,
      sd_err=2,
      seed = 92220
      ){
        df_alloc = df_alloc[order(df_alloc$ID),]
        set.seed(seed)
        df_alloc_full = df_alloc
        ## First add the three latent variables
        n_total = nrow(df_alloc_full)
        hidden_norm = rnorm(n=n_total, mean=0, sd=1)
        hidden_unif = runif(n=n_total, min=0, max=1)
        ## THIS ISN'T WORKING - EVERYONE GETS B
        ## This is because it relies on input$n_per_arm, which will be set to 1 when people are going back in
        ## Change it so it reads the size of the uploaded data frame 
        hidden_cat = as.factor(sample(c("A", "B", "C"), size=n_total, replace=T))
        
        df_alloc_full$hid_norm = hidden_norm
        df_alloc_full$hid_unif = hidden_unif
        df_alloc_full$hid_cat = hidden_cat
        
        n_tot = nrow(df_alloc)
        coef_baseline_rand = rnorm(
          n=n_total, 
          mean = coef_baseline,
          sd = sd_coef_baseline
        )
        coef_BMI_rand = rnorm(
          n=n_total, 
          mean = coef_BMI,
          sd = sd_coef_BMI
        )
        
        
        out_temp = coef_baseline_rand*df_alloc_full$baseline + 
          coef_arm*as.numeric(df_alloc_full$arm) + 
          coef_sex*as.numeric(df_alloc_full$sex) +
          coef_BMI*as.numeric(df_alloc_full$BMI) +
          coef_armsex*as.numeric(df_alloc_full$arm)*as.numeric(df_alloc_full$sex)+ 
          coef_armage*as.numeric(df_alloc_full$arm)*(df_alloc_full$age - 50)+
          coef_norm*df_alloc_full$hid_norm +
          coef_unif*df_alloc_full$hid_unif +
          coef_cat*as.numeric(df_alloc_full$hid_cat) +
          rnorm(n_tot, mean=0, sd=sd_err)
#        df_alloc_full$outcome = out_temp
#        df_alloc_full
        df_alloc$outcome = out_temp
        df_alloc
      } 

    set.seed(92220)
    req(input$file1)
    
    df <- read.csv(input$file1$datapath,
                   header = T,
                   sep = input$sep,
                   quote = "")
    if(is.character(df$arm)){
      df$arm = as.factor(df$arm)
    }
    if(is.character(df$sex)){
      df$sex = as.factor(df$sex)
    }
    df_run = run_trial(df)
 #   df_nohidden = df_run[,c(1,2,3,4,5,9)]
#    df_nohidden
    df_run
  })
  
  output$results <- renderTable({
    res_data()
  })
    
  output$download_results <- downloadHandler(
    filename = function(){"trial_results.csv"}, 
    content = function(fname){
      write.csv(res_data(), fname, quote=F, row.names=F)
    }
  )
  

}