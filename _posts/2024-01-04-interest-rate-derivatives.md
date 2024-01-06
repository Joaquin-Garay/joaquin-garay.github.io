---
title: Interest Rate Derivatives
author: Joaquin Garay
date: 2024-01-04
category: fixed-income
layout: post
---

Covering Term Structure bootstrapping, Swaps, and other derivatives. I will try to include Python QuantLib application examples of these instruments.

## Market calendar conventions
<!-- This is a comment and won't show up in the rendered Markdown -->


### Day counting
The day count defines the way in which interest accrues over time.
- **Actual/360**: It counts the number of actual days between two days ($d_2$ and $d_1$) over a year basis of 360 years.
  
$$Yf = \frac{d_2 - d_1}{360}$$
  
- **Actual/365 Fixed**: Similarly, this convention considers years of 365 days.
  
$$Yf = \frac{d_2 - d_1}{365}$$
  
- **30/360**: It considers months of 30 days each. The are several conventions of how to treat non-30days months, but in general it follows:
  
$$Yf = \frac{360(Y_2 - Y_1) + 30(M_2 - M_1) + D_2 - D_1}{360}$$
  
- **Actual/Actual**:

$$ Yf = \frac{\text{Days in non-leap years}}{365} + \frac{\text{Days in leap years}}{366}$$
  
- **30/30 or Actual/30**: Instead of a year fraction, this calculate a month fraction with a basis of 30-days month, considering each month is 30 days each. This convention is often used in some Chilean instruments.

### Compounding conventions
The are three different ways to calculate a wealth factor or its reciprocal discount factor.
- **Simple or linear**:

$$ WF = (1 + r)\cdot Yf $$

- **Compounded**:

$$ WF = (1 + r)^{Yf}$$

- **Continuous or exponential**:

$$ WF = \exp \left[ r \cdot Yf \right]$$

It is important to have in mind that the same wealth factor can have different interest rates depending on the compounding and day counting conventions.

### Business day adjustments conventions
This conventions will depend on the calendar or joint calendar that is being used in the contract of the instrument. It adjusts the end date of the accrual period in the case it is holiday.

- **Following**: The adjusted day is the following business day.
- **Preceding**: The adjusted day is the preceding business day.
- **Modified Following**: The adjusted day will be the following day if it's within the same month, otherwise the adjusted day is the preceding business day.
- **Modified Preceding**: The adjusted day will be the preceding day if it's within the same month, otherwise the adjusted day is the following business day.
- **End of month bolean**: Where the start date of a period is on the final business day of a particular calendar month, the end date is on the final business day of the end month (not necessarily the corresponding date in the end month).

## Interest Rate Swaps

A swap is an over-the-counter agreement between two companies to exchange cash flows in the future. The agreement defines the dates when the cash flows are to be paid and the way in which they are to be calculated. Usually the calculation of the cash flows involves the future value of an interest rate, an exchange rate, or other market variable.

A swap 


## Reference
- Hull, John C., *Options, Futures, and Other Derivatives*. 11th ed., Pearson, 2021.
- Ametrano, Ferdinando M., and Marco Bianchetti. *Everything You Always Wanted to Know About Multiple Interest Rate Curve Bootstrapping but Were Afraid to Ask.* April 2, 2013. SSRN. https://ssrn.com/abstract=2219548 or http://dx.doi.org/10.2139/ssrn.2219548
- Henrard, Marc P. A. *Interest Rate Instruments and Market Conventions Guide.* First Edition. OpenGamma Quantitative Research, April 2012. SSRN. https://ssrn.com/abstract=2128257.





