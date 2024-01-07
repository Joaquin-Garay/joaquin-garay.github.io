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

## Introduction to Interest Rate Swaps

A swap is an over-the-counter agreement between two companies to exchange cash flows in the future. The agreement defines the dates when the cash flows are to be paid and the way in which they are to be calculated. Usually the calculation of the cash flows involves the future value of an interest rate, an exchange rate, or other market variable.

A swap consists of two parts or "legs": one leg involves making payments accrued at a specific rate, and the other leg involves receiving payments at a different rate. Commonly, one of the legs is calculated using a fixed interest rate, thus it's called the **fixed leg**, and the other leg is calculated using a variable rate over time, with its future values unknown, known as the **floating leg.** These two legs can differ in their periodicity and how they account for their year fraction.

I'll continue considering this fixed-for-floating swap type, even though they are a vast diversity of swaps: fixed-for-fixed with different currency, floating-for-floating, volatility swaps, commodity swaps, equity swap, credit default swaps, etc.

### Why to enter an Interest Rate Swap

There are many uses and example why a company should enter a swap. In the simpliest, a company could transform a floating loan into a fixed one to protect themself against rate increments. In that case, they would want to recieve floating rate and pay fixed rate, hence hedging the interest rate risk completly. Another example is a companing owning a bond paying fixed rate and they want exposure to the interest rate market, they transforms the bond coupons into floating one entering a swap in which they pay fixed rate.

### Swap setup

To setup a swap contract, we need to define a serie of parameters such us:
- **Calendar**: To know which calendar days are good business days. If the contract is establish between two foreign companies, i.e. London-New York, a joint calendar ruling out holidays of both calendars has to be considered.
- **Leg Currency**: Of both fixed and floating leg.
- **Leg Business day convention**: e.g. Modified Following.
- **Leg Day count convention**: e.g. Actual/360.
- **Leg Coupon frequency**: Period of time in which the notional accrues interest, e.g. 6-Month.
- **Leg Notional principal**: for example USD 10M.
- **Leg rate compounding**: Usually linear.
- **Fixed rate value**: e.g. 3%.
- **Floating rate index**: Such us Libor or an overnight index. We'll come back on this. Some of the above parameters would be inherent in the index.
- **Floating rate spread**: An additional fixed value added to the floating rate.
- **Floating rate gearing**: Ratio of the floating rate considered in the contract.

### Overnight Indexed Swaps (OIS)

**Overnight Indexes**

Banks are required to maintain a certain amount of liquidity, known as a reserve, with the central banks of the country. The reserve requirements for a bank at any time depend on its assets and liabilities. At the end of a day, some financial institutions typically have surplus funds in their accounts with the central bank while others lack the minimum required. This leads to overnight loans. In the United States, the central bank is the Federal Reserve (usually referred to as the Fed) and the overnight rate is known as the Federal Funds Rate. The weighted average of uncollateralized financing transactions reported to the Fed is what which determines the Federal Funds Rate.

Some overnight index

## General pricing formula for collateralized derivative

### Funding and collateral

### Pricing under collateral

## Yield curves bootstraping

















## Reference
- Hull, John C., *Options, Futures, and Other Derivatives*. 11th ed., Pearson, 2021.
- Ametrano, Ferdinando M., and Marco Bianchetti. *Everything You Always Wanted to Know About Multiple Interest Rate Curve Bootstrapping but Were Afraid to Ask.* April 2, 2013. SSRN. https://ssrn.com/abstract=2219548 or http://dx.doi.org/10.2139/ssrn.2219548
- Henrard, Marc P. A. *Interest Rate Instruments and Market Conventions Guide.* First Edition. OpenGamma Quantitative Research, April 2012. SSRN. https://ssrn.com/abstract=2128257.
