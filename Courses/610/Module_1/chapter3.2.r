
##########################################
# section 3.2 Exploratory Data Analysis
##########################################

rnorm(5, mean=0, sd=0.05) # returns ~ -0.054803075  0.052909353 -0.078346041 -0.005976294 -0.038686762

# Figure 3-5
x <- rnorm(50)
y <- x + rnorm(50, mean=0, sd=0.5)

data <- as.data.frame(cbind(x, y))
summary(data)

library(ggplot2)
# aes
# 
ggplot(data, aes(x=x, y=y)) +
  geom_point(size=2) +                                     # dot size
  ggtitle("Scatterplot of X and Y") +                      # title
  theme(axis.text=element_text(size=12),                   # Font Size of X & Y axis markers
        axis.title = element_text(size=14),                # Font size Axis Legend/Title
        plot.title = element_text(size=20, face="bold"))   # Font size entire plot title

##########################################
# section 3.2.1 Visualization Before Analysis
##########################################

library(ggplot2)

data(anscombe)
anscombe
nrow(anscombe)   # Returns number of rows for dataset

# generates levels to indicate which group each data point belongs to
# gl(): Generate Factor Levels
levels <- gl(4,nrow(anscombe))
levels

# Group anscombe into a data frame
# with(): Evaluate an Expression in a Data Environment
# ??????????????????? How does this work?
mydata <- with(anscombe,data.frame(x=c(x1,x2,x3,x4), y=c(y1,y2,y3,y4), mygroup=levels))
mydata

# My noodles
hanscombe <- head(anscombe, n=5)
hanscombe
hlevels <- gl(4,nrow(hanscombe))
hlevels
hmydata <- with(hanscombe,data.frame(x=c(x1,x2,x3,x4), y=c(y1,y2,y3,y4), mygroup=hlevels))
hmydata

# Make scatterplots using the ggplot2 package
# themeset(): Get, set, and modify the active theme
# theme_bw(): colors... gray, light, dark..classic
theme_set(theme_bw()) # set plot color theme

# create the four plots of Figure 3-7
ggplot(mydata, aes(x,y)) +                            # 
  geom_point(size=4) +                                # size of dots
  geom_smooth(method="lm", fill=NA, fullrange=TRUE) + # 
  facet_wrap(~mygroup)                                #

# Facet_wrap
# The above is a terrible demonstration, this video wayyyy better.
# https://www.youtube.com/watch?v=wGDdJo1qPXM
# 

##########################################
# section 3.2.2 Dirty Data
##########################################

# uniform distribution
runif(5, min=-1, max=0)

rep(0,5)                    # returns [1] 0 0 0 0 0

# simple version
##############


# ??????????? I must review how to create data
age <- rnorm(6000, mean=40, sd=10) 
age <- c( age, runif(20, min=-2, max=0), 
          rep(0,400), 
          runif(40, min=100, max=110))
age <- round(age)

hist(age, breaks=100, main="Age Distribution of Account Holders",
     xlab="Age", ylab="Frequency", col="gray")

x <- c(1, 2, 3, NA, 4)
is.na(x)                            # returns [1] FALSE FALSE FALSE  TRUE FALSE

mean(x)                             # returns NA
mean(x, na.rm=TRUE)                 # returns 2.5

DF <- data.frame(x = c(1, 2, 3), y = c(10, 20, NA))
DF

DF1 <- na.exclude(DF)               # removes rows w/o NA
DF1

mortgage <- rbeta(2000,2,4) * 10                 # The Beta Distribution
head(mortgage)
# rep() creates 1000 copies of 10
hist(mortgage, breaks=10, xlab="Mortgage Age", col="gray",  # Troubleshooting plot
     main="Portfolio Distribution, Years Since Origination")

c(rep(2, 3), rep(10, 5))                       # returns 2  2  2 10 10 10 10 10

# C just contactonates
mortgage <- c(mortgage, rep(10, 1000)) 
head(mortgage)

hist(mortgage, breaks=10, xlab="Mortgage Age", col="gray",
     main="Portfolio Distribution, Years Since Origination")

##########################################
# section 3.2.3 Visualizing a Single Variable
##########################################
data(mtcars)

## Dotchart and Barplot ##

dotchart(mtcars$mpg,labels=row.names(mtcars),cex=.7,
         main="Miles Per Gallon (MPG) of Car Models",
         xlab="MPG")
barplot(table(mtcars$cyl), main="Distribution of Car Cylinder Counts",
        xlab="Number of Cylinders")


## Histogram and Density Plot ##

# randomly generate 4000 observations from the log normal distribution
income <- rlnorm(4000, meanlog = 4, sdlog = 0.7)
head(income)
summary(income)

income <- 1000*income
summary(income)

# plot the histogram
hist(income, breaks=500, xlab="Income", main="Histogram of Income")
# density plot - no log 10
# density(): Kernel Density Estimation 
# https://www.youtube.com/watch?v=PBZVTjmhl74

# density statistics
density(income, adjust=0.5)

# plot the statistics of income - noodling
# ???? Why pick 0.5......???????????????
plot(density(income, adjust=0.5),
     main="Distribution of Income (log10 scale)")
# density plot - no log 10 adjust 8 - noodling
plot(density(income, adjust=8),
     main="Distribution of Income (log10 scale)")


# density plot with log 10
plot(density(log10(income), adjust=0.5),
     main="Distribution of Income (log10 scale)")
# add rug to the density plot
rug(log10(income))


library("ggplot2")

theme_set(theme_grey())

data(diamonds) # load the diamonds dataset from ggplot2
head(diamonds)

# Only keep the premium and ideal cuts of diamonds
niceDiamonds <- diamonds[diamonds$cut=="Premium" |
                           diamonds$cut=="Ideal",]
head(niceDiamonds)

summary(niceDiamonds$cut)

# plot density plot of diamond prices
# geom_density: Smoothed density estimates
ggplot(niceDiamonds, aes(x=price, fill=cut)) +
  geom_density(alpha = .3, color=NA)
# plot density plot of the log10 of diamond prices
ggplot(niceDiamonds, aes(x=log10(price), fill=cut)) +
  geom_density(alpha = .3, color=NA)

##########################################
# section 3.2.4 Examining Multiple Variables
##########################################

# 75 numbers between 0 and 10 of uniform distribution
x <- runif(75, 0, 10)                    # uniform distribution 75 reps from 0 to 10, 
is.unsorted(x)
x <- sort(x)
is.unsorted(x)
# rnorm() : The normal distribution
# This formula is the standard we are creating
y <- 200 + x^3 - 10 * x^2 + x + rnorm(75, 0, 20)
lr <- lm(y ~ x) # linear regression
lr # prints out coefficient & intercetp
poly <- loess(y ~ x) # LOESS Local Polynomial Regression Fitting
poly # prints out number of observations, Residual Standard Error, Equivalent Number of Parameters


# ???????????????? Rview this
# predict() : eneric function for predictions from the results of various model fitting functions. 
fit <- predict(poly) # fit a nonlinear line
fit
plot(x,y)



# draw the fitted line for the linear regression
# points(): Add Points to a Plot
# ??????? what does col mean?
points(x, lr$coefficients[1] + lr$coefficients[2] * x,
       type = "l", col = 2)
lr$coefficients[1]
lr$coefficients[2]


# draw the fitted line with LOESS
points(x, fit, type = "l", col = 4)

## Dotchart and Barplot ##

# sort by mpg
cars <- mtcars[order(mtcars$mpg),]
# grouping variable must be a factor
# ???????? deep dive on why grouping must be factor.
cars$cyl <- factor(cars$cyl)
cars$color[cars$cyl==4] <- "red"
  #### White space in R????????????????????/
  cars$color[cars$cyl==6] <- "blue"
    cars$color[cars$cyl==8] <- "darkgreen"
      dotchart(cars$mpg, labels=row.names(cars), cex=.7, groups= cars$cyl,
               main="Miles Per Gallon (MPG) of Car Models\nGrouped by Cylinder",
               xlab="Miles Per Gallon", color=cars$color, gcolor="black")
      
      counts <- table(mtcars$gear, mtcars$cyl)
      barplot(counts, main="Distribution of Car Cylinder Counts and Gears",
              xlab="Number of Cylinders", ylab="Counts",              # X & Y labels
              col=c("#0000FFFF", "#0080FFFF", "#00FFFFFF"),
              legend = rownames(counts), beside=TRUE,
              args.legend = list(x="top", title = "Number of Gears"))
      
      
      ## Box-and-Whisker Plot ##
      
      DF <- read.csv("c:/data/zipIncome.csv", header=TRUE, sep=",")
      
      # Remove outliers
      # Does this manually with subset() which removes those <7k and > 200k
      DF <- subset(DF, DF$MeanHouseholdIncome > 7000 & DF$MeanHouseholdIncome < 200000) 
      summary(DF)
      
      library(ggplot2)
      # plot the jittered scatterplot w/ boxplot
      # color-code points with zip codes
      # the outlier.size=0 prevents the boxplot from plotting the outlier
      head(DF)
      # This is soooo pretty!!!!!!!!!!!!!
      ggplot(data=DF, aes(x=as.factor(Zip1), y=log10(MeanHouseholdIncome))) +
        # Jitter gives width
        # factor(groups and put thngs into colors based on zip)
        geom_point(aes(color=factor(Zip1)), alpha=0.2, position="jitter") +
        geom_boxplot(outlier.size=0, alpha=0.1) +
        guides(colour=FALSE) +
        ggtitle ("Mean Household Income by Zip Code")
      
      # simple boxplot
      boxplot(log10(MeanHouseholdIncome) ~ Zip1, data=DF)
      title ("Mean Household Income by Zip Code")
      
      ## Hexbinplot for Large Datasets ##
      
      # plot the data points
      plot(log10(MeanHouseholdIncome) ~ MeanEducation, data=DF)
      # add a straight fitted line of the linear regression
      abline(lm(log10(MeanHouseholdIncome) ~ MeanEducation, data=DF),
             col='red')
      
      
      install.packages("hexbin")
      library(hexbin)
      #
      # "g" adds the grid, "r" adds the regression line
      # sqrt transform on the count gives more dynamic range to the shading
      # inv provides the inverse transformation function of trans
      #
      hexbinplot(log10(MeanHouseholdIncome) ~ MeanEducation,
                 data=DF, trans = sqrt, inv = function(x) x^2,
                 type=c("g", "r"))
      
      
      hexbinplot(log10(MeanHouseholdIncome) ~ MeanEducation,
                 data=DF, inv = function(x) x^2,
                 type=c("g", "r")) # More black and wide, less gradients.
      
      
      hexbinplot(log10(MeanHouseholdIncome) ~ MeanEducation,
                 data=DF, trans = sqrt,
                 type=c("g", "r"))  # This errors out
      
      ## Scatterplot Matrix ##
      
      # define the colors
      colors <- c("red", "green", "blue")
      #colors <- c("gray50", "white", "black")
      
      # draw the plot matrix
      # pairs() Scatterplot Matrices
      # unclass() 
      pairs(iris[1:4], main = "Fisher's Iris Dataset",
            pch = 21, bg = colors[unclass(iris$Species)] )
      # set graphical parameter to clip plotting to the figure region
      # ??????????
      par(xpd = TRUE)
      # add legend
      legend(0.2, 0.02, horiz = TRUE, as.vector(unique(iris$Species)),
             fill = colors, bty = "n")
      
      
      ## Analyzing a Variable over Time ##
      
      plot(AirPassengers)
      
      ##########################################
      # section 3.2.5 Data Exploration Versus Presentation
      ##########################################
      
      # Generate random log normal income data
      # rlnorm : The Log Normal Distribution 
      income = rlnorm(5000, meanlog=log(40000), sdlog=log(5))
      # Part I: Create the density plot
      plot(density(log10(income), adjust=0.5),
           main="Distribution of Account Values (log10 scale)")
      # Add rug to the density plot
      rug(log10(income))
      
      # Part II: Make the histogram
      # Create "log-like bins"
      breaks = c(0, 1000, 5000, 10000, 50000, 100000, 5e5, 1e6, 2e7)
      # Create bins and label the data
      # cut : Convert Numeric to Factor
      bins = cut(income, breaks, include.lowest=T,
                 labels = c("< 1K", "1-5K", "5-10K", "10-50K",
                            "50-100K", "100-500K", "500K-1M", "> 1M"))
      # Plot the bins
      plot(bins, main = "Distribution of Account Values",
           xlab = "Account value ($ USD)",
           ylab = "Number of Accounts", col="blue")