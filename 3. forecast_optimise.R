

# ---- forecasting series using additive local regression (algorithm provided by facebook) ----

forecast_out <- function(time_id, value){
    
    df <- cbind(time_id,  log(value))
    names(df) <- c("ds","y")
    
    rc <- prophet(df = df , growth = "linear",
                  changepoints = NULL,
                  n.changepoints = 25, 
                  yearly.seasonality = "auto",
                  weekly.seasonality = "auto", 
                  holidays = NULL,
                  seasonality.prior.scale = 10, 
                  holidays.prior.scale = 10,
                  changepoint.prior.scale = 0.05,
                  mcmc.samples = 0, 
                  interval.width = 0.8,
                  uncertainty.samples = 1000, 
                  fit = TRUE)
    return(rc)
}

m <- forecast_out(service_realible$date, service_realible[4])


future <- make_future_dataframe(m, periods = 365)
tail(future)


forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])

plot(m, forecast)

prophet_plot_components(m, forecast)



