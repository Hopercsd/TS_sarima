serie=window(ts(read.table("pasajebcn.dat"),start=1997,freq=12))

plot(serie, main="Passengers in the port of Barcelona.", ylab="Thousand of passengers")
abline(v=1997:2020,lty=3,col=4)

# 1. Identification: 

# a) Determine the needed transformations to make the series stationary. Justify the transformations
# carried out using graphical and numerical results. 


(m<-apply(matrix(serie, nr=12),2,mean))
(v<-apply(matrix(serie, nr=12),2,var))
plot(v~m)

boxplot(serie~floor(time(serie)))

lnserie = log(serie)
plot(lnserie)

(m<-apply(matrix(lnserie, nr=12),2,mean))
(v<-apply(matrix(lnserie, nr=12),2,var))
plot(v~m)
boxplot(lnserie~floor(time(serie)))


print("Variance of origin time series:")
print(var(serie))
print("Difference of var original with var of ln series:")
print(var(serie)-var(lnserie))
if (var(serie)-var(lnserie) > 0){
  print('Variance decreased. Transformation kept')
}

monthplot(lnserie)
ts.plot(matrix(lnserie, nr=12))
d12lnserie = diff(lnserie, 12)
plot(d12lnserie)
abline(h=0)

monthplot(d12lnserie)
ts.plot(matrix(d12lnserie, nr=12))

print("Difference of var diff 12 with var of ln series:")
print(var(lnserie)-var(d12lnserie))
if (var(lnserie)-var(d12lnserie) > 0){
  print('Variance decreased. Transformation kept')
}


d1d12lnserie <- diff(d12lnserie, lag=1)
plot(d1d12lnserie)
abline(h=0)

print("Difference of var diff 12 with var of diff1 and diff12 series:")
print(var(d12lnserie)-var(d1d12lnserie))
if (var(d12lnserie)-var(d1d12lnserie) > 0){
  print('Variance decreased. Transformation kept')
}

# Variance increased so the diff(1) is not kept

# Final: Wt=(1-B^12)log(Xt)
  


# b) Analyze the ACF and PACF of the stationary series to identify at least two plausible models. Reason
# about what features of the correlograms you use to identify these models. 



par(mfrow=c(1,2))
acf(d12lnserie,ylim=c(-1,1),col=c(2,rep(1,11)),lwd=2,lag.max=72)
pacf(d12lnserie,ylim=c(-1,1),col=c(rep(1,11),2),lwd=2,lag.max=72)
par(mfrow=c(1,1))

# From PACF -> AR(p) = AR(2), AR(P)=AR(1)
# Model from ACF -> MA(q) = MA(5) or MA(8). We reject that. for MA(Q) = MA(1)
# Since ACF has decreasing lags and then alternated, it is better to select a model from PACF
# d,D -> (0,1)
# 1st model: (S)ARIMA(2,0,0)(1,1,0)12
# 2nd model: (S)ARIMA(2,0,0)(0,1,1)12


# 2. Estimation:
#  a) Use R to estimate the identified models. 

(mod1=arima(lnserie,order=c(2,0,0),seasonal=list(order=c(1,1,0),period=12)))

(mod2=arima(lnserie,order=c(2,0,0),seasonal=list(order=c(0,1,1),period=12)))


