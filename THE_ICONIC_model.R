# set work space to the current Iconic folder
setwd('/Users/ifairyvoice/Mpro/R/Iconic')

# install and load neccessary libraries
if (!require('jsonlite')) install.packages('jsonlite'); library('jsonlite')

# load raw data
X.raw=read_json("data/data.json", simplifyVector = TRUE)
X=X.raw[,-1]

# fix wacc_items
wi=X$male_items - X$mapp_items - X$mftw_items - X$mspt_items
X$macc_items=ifelse(wi>0,wi,0)

# convert is_newsletter_subscriber from N/Y to 0/1
X$is_newsletter_subscriber=ifelse(X$is_newsletter_subscriber=="N",0,1)

# assign default value to coupon_discount_applied
cn=length(X$coupon_discount_applied[which(is.na(X$coupon_discount_applied))])
X$coupon_discount_applied[which(is.na(X$coupon_discount_applied))]=rnorm(cn,mean(X$coupon_discount_applied[!is.na(X$coupon_discount_applied)]),
                                                 (max(X$coupon_discount_applied[!is.na(X$coupon_discount_applied)])-
                                                      min(X$coupon_discount_applied[!is.na(X$coupon_discount_applied)]))/4)

X.s=X

# data normalisation
X=as.data.frame(scale(X))

# check correlation between features and remove the ones strongly correlated to others
cor(X)

# check feature variance 
apply(X.raw,2,var)

# remove the following features with strong correlation to other:
X=X[ , !(names(X) %in% c("female_items","wapp_items","mapp_items"))]

# remove the following features with low variance:
X=X[ , !(names(X) %in% c("apple_payments","other_device_orders"))]

Y=kmeans(X,2)

# check the cluster result versus which is more between male_items and female_items
plot((X.raw$female_items+0.1)/(X.raw$male_items+0.1),type="p",col=Y$cluster,
     ylab='female_items / male_items')

# correlation between the inferred gender and given features
cor(X,Y$cluster)
