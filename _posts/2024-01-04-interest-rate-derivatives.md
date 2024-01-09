---
title: Interest Rate Derivatives
author: Joaquin Garay
date: 2024-01-04
category: fixed-income
layout: post
---

Covering Term Structure bootstrapping, Swaps, and other derivatives. I will try to include Python QuantLib application examples of these instruments.

## Market Calendar Conventions
<!-- This is a comment and won't show up in the rendered Markdown -->


### Day Counting
The day count defines the way in which interest accrues over time.
- **Actual/360**: It counts the number of actual days between two days ($d_2$ and $d_1$) over a year basis of 360 years.
  
$$Yf = \frac{d_2 - d_1}{360}$$
  
- **Actual/365 Fixed**: Similarly, this convention considers years of 365 days.
  
$$Yf = \frac{d_2 - d_1}{365}$$
  
- **30/360**: It considers months of 30 days each. The are several conventions of how to treat non-30days months, but in general it follows:
  
$$Yf = \frac{360(Y_2 - Y_1) + 30(M_2 - M_1) + D_2 - D_1}{360}$$
  
- **Actual/Actual**:

$$ Yf = \frac{\text{Days in non-leap years}}{365} + \frac{\text{Days in leap years}}{366}$$
  
- **Actual/30**: Instead of a year fraction, this calculate a month fraction with a basis of 30-days month. This convention is often used in some Chilean instruments.

### Compounding Conventions
There are three different ways to calculate a wealth factor or its corresponding discount factor.
- **Simple or linear**:

$$ WF = (1 + r)\cdot Yf $$

- **Compounded**:

$$ WF = (1 + r)^{Yf}$$

- **Continuous or exponential**:

$$ WF = \exp \left[ r \cdot Yf \right]$$

It is important to have in mind that the same wealth factor can have different interest rates depending on the compounding and day counting conventions.

### Business day adjustments conventions
These conventions will depend on the calendar or joint calendar that is being used in the contract of the instrument. It adjusts the end date of the accrual period in the case it is holiday.

- **Following**: The adjusted day is the following business day.
- **Preceding**: The adjusted day is the preceding business day.
- **Modified Following**: The adjusted day will be the following day if it's within the same month, otherwise the adjusted day is the preceding business day.
- **Modified Preceding**: The adjusted day will be the preceding day if it's within the same month, otherwise the adjusted day is the following business day.
- **End of month bolean**: Where the start date of a period is on the final business day of a particular calendar month, the end date is on the final business day of the end month (not necessarily the corresponding date in the end month).

## Introduction to Interest Rate Swaps

A swap is an over-the-counter agreement between two companies to exchange cash flows in the future. The agreement defines the dates when the cash flows are to be paid and the way in which they are to be calculated. Usually the calculation of the cash flows involves the future value of an interest rate, an exchange rate, or other market variable.

A swap consists of two parts or "legs": one leg involves making payments accrued at a specific rate, and the other leg involves receiving payments at a different rate. Commonly, one of the legs is calculated using a fixed interest rate, thus it's called the **fixed leg**, and the other leg is calculated using a variable rate over time, with its future values unknown, known as the **floating leg.** These two legs can differ in their periodicity and how they account for their year fraction.

I'll continue considering this fixed-for-floating swap type, even though they are a vast diversity of swaps: fixed-for-fixed with different currency, floating-for-floating, volatility swaps, commodity swaps, equity swap, credit default swaps, etc.

### Why Enter an Interest Rate Swap?

There are many uses and example why a company should enter a swap. In the simpliest, a company could transform a floating loan into a fixed one to protect themself against rate increments. In that case, they would want to recieve floating rate and pay fixed rate, hence hedging the interest rate risk completly. Another example is a companing owning a bond paying fixed rate and they want exposure to the interest rate market, they transforms the bond coupons into floating one entering a swap in which they pay fixed rate.

### Swap Setup

To setup a swap contract, we need to define a serie of parameters such us:
- **Calendar**: To know which calendar days are good business days. If the contract is establish between two foreign companies, i.e. London-New York, a joint calendar ruling out holidays of both calendars has to be considered.
- **Leg Currency**: Of both fixed and floating leg.
- **Leg Business day convention**: e.g. Modified Following. The termination day could have a different convention.
- **Leg Day count convention**: e.g. Actual/360.
- **Leg Coupon frequency and Stub period convention**: Period of time in which the notional accrues interest, e.g. 6-Month. The stub period is the irregular shorter period in case the maturity division has a remainder, it could be placed at the begining or at the end.
- **Leg Notional principal**: for example USD 10M.
- **Leg rate compounding**: Usually linear.
- **Fixed rate value**: e.g. 3%.
- **Floating rate index**: Such us Libor or an overnight index. We'll come back on this. Some of the above parameters would be inherent in the index.
- **Floating rate spread**: An additional fixed value added to the floating rate.
- **Floating rate gearing**: Ratio of the floating rate considered in the contract.

Here and example of a floating leg of a LIBOR 3M swap. Fictional data.
<style>
.table-wrapper {
    font-size: smaller;
}
</style>
<div class="table-wrapper" markdown="block">

| Start Date | End Date   | Fixing Date | Payment Date | Notional    | Amortization | Interest | Cashfow     | Currency | Rate Index | Rate Value | Spread | Gearing | Rate Convention |
|------------|------------|-------------|--------------|-------------|--------------|----------|-------------|----------|------------|------------|--------|---------|-----------------|
| 2020-09-17 | 2020-12-17 | 2020-09-15  | 2020-12-17   | -10,000,000 | 0            | -6,222   | -6,222      | USD      | LIBORUSD3M | 0.25%      | 0.00%  | 1       | LinAct360       |
| 2020-12-17 | 2021-03-17 | 2020-12-15  | 2021-03-17   | -10,000,000 | 0            | -6,153   | -6,153      | USD      | LIBORUSD3M | 0.25%      | 0.00%  | 1       | LinAct360       |
| 2021-03-17 | 2021-06-17 | 2021-03-15  | 2021-06-17   | -10,000,000 | 0            | -6,290   | -6,290      | USD      | LIBORUSD3M | 0.25%      | 0.00%  | 1       | LinAct360       |
| 2021-06-17 | 2021-09-17 | 2021-06-15  | 2021-09-17   | -10,000,000 | 0            | -6,290   | -6,290      | USD      | LIBORUSD3M | 0.25%      | 0.00%  | 1       | LinAct360       |
| 2021-09-17 | 2021-12-17 | 2021-09-15  | 2021-12-17   | -10,000,000 | 0            | -6,222   | -6,222      | USD      | LIBORUSD3M | 0.25%      | 0.00%  | 1       | LinAct360       |
| 2021-12-17 | 2022-03-17 | 2021-12-15  | 2022-03-17   | -10,000,000 | 0            | -6,153   | -6,153      | USD      | LIBORUSD3M | 0.25%      | 0.00%  | 1       | LinAct360       |
| 2022-03-17 | 2022-06-17 | 2022-03-15  | 2022-06-17   | -10,000,000 | 0            | -6,290   | -6,290      | USD      | LIBORUSD3M | 0.25%      | 0.00%  | 1       | LinAct360       |
| 2022-06-17 | 2022-09-19 | 2022-06-15  | 2022-09-19   | -10,000,000 | -10,000,000  | -6,427   | -10,006,427 | USD      | LIBORUSD3M | 0.25%      | 0.00%  | 1       | LinAct360       |

</div>

### Overnight Indexed Swaps (OIS)

**Overnight Indexes**

Banks are required to maintain a certain amount of liquidity, known as a reserve, with the central banks of the country. The reserve requirements for a bank at any time depend on its assets and liabilities. At the end of a day, some financial institutions typically have surplus funds in their accounts with the central bank while others lack the minimum required. This leads to overnight loans. In the United States, the central bank is the Federal Reserve (usually referred to as the Fed) and the overnight rate is known as the Federal Funds Rate. The weighted average of uncollateralized financing transactions reported to the Fed is what which determines the Federal Funds Rate.

There are uncollateralized (unsecured) and collateralized (secured) borrowing overnight rates, here is a short list.

Unsecured Overnight Rates:
- Federal Funds Rate (USD) - United States, actual/360.
- Euro Overnight Index Average (EONIA) (EUR) - Eurozone, actual/360.
- Sterling Overnight Index Average (SONIA) (GBP) - United Kingdom, actual/365 (fixed).
- Tokyo Overnight Average Rate (TONAR) (JPY) - Japan, actual/365 (fixed).
- Euro Short-Term Rate (€STR) (EUR) - Eurozone, actual/360.

Secured Overnight Rates:
- Secured Overnight Financing Rate (SOFR) (USD) - United States, actual/360.
- Repo Overnight Index Average (RONIA) (GBP) - United Kingdom, actual/365 (fixed).
- Tokyo Repo Rate (JPY) - Japan, actual/365 (fixed).
- Broad General Collateral Rate (BGCR) (USD) - United States, actual/360.
- Tri-Party General Collateral Rate (TGCR) (USD) - United States, actual/360.

**Overnight Indexed Swap**

An Overnight indexed swap is simply an fixed-for-floating swap where the floating rate is some overnight index. OISs play an important role in determining the risk-free rates which are needed for valuing derivatives. Overnight reference rates are considered to be better proxies for risk-free rates than Treasury rates. 

When first entered into, OISs (and any swap in general) should have value of zero, i.e. the present value of the cash flows of the fixed leg should be equal to the present value of the cash flows of the floating leg. This means there's a unique fixed rate that makes this happend, often called *fair rate* or *OIS rate* in this case. We can observe OIS rates of a range of swap maturities in the market. OIS rates with maturities until one year, provide directly the risk-free zero rate that are equivalent to the underlying overnight rates. Greater maturities have two or more coupons and another process is needed to calculate the zero rates, called *Yield curve bootstrapping* discussed below. 

![Swap Bloomberg Book](assets/SwapBook.png)


## General pricing formula for collateralized derivative

The Amedrano & Biachetti approach of how to price a derivative under collateral is presented below.

### Collateral Use

Generally, collateral is an "asset" that a borrower offers to a lender as security for a loan. It serves as a form of protection for the lender; if the borrower defaults on the loan, the lender has the right to seize the collateral to recoup their losses. In derivatives market, it's a bit different.

CSA is often colloquially referred to when discussing a collateral agreement set up according to the principles of the *Credit Support Annex*. The CSA is a document that defines the terms and conditions for providing collateral by the parties in a derivative transaction. It is one of the four parts of a *master agreement* developed by the *International Swaps and Derivatives Association (ISDA)*.

The following provisions are part of a typical CSA agreement:
1. **Eligible Credit Support**: Eligible credit support are a list of eligible collaterals, which could be posted. E.g. cash in one or more currency, cash equivalents, government securities etc. Fixed income securities are often valued with a "haircut", a small discount from its market value.
2. **Initial margin**: Initial margin or “Independent Amount (IA)” refers to the amount that the counterparties may need to transfer at the commencement of their relationship. IA can also take the form of an agreed sum to be transferred during the tenor of the agreement, if the risk exposure on a particular transaction warrants it or the inherent risk profile of a counterparty changes. E.g. incidents of credit/ratings downgrade. Not always is established as a positive quantity.
3. **Margin call**: A margin call is a demand by one counterparty party to the other for depositing additional collateral to cover possible losses due to overexposure. Margin calls are generally triggered on a counterparty level, this means it takes into consideration the whole derivative portfolio between the counterparties, and not just an specific instrument.
4. **Close-out netting**: Close-out netting is a method where, in the event of a contract default, the obligations are terminated and the positive and negative values of replacements are combined. This results in a single amount that is either owed or receivable, simplifying the settlement process. The applicable legislation must allow this mechanism.
5. **Margin call frequency**: Margin call frequency refers to the periodic timescale after which collateral may be called.
6. **Threshold amount (TH)**: It is the level of unsecured (marked-to-market) exposure each counterparty will allow the other before any margin call is made. The TH can be different for each counterparty and is tipically defined by their credit ratings.
7. **Minimum Transfer Amount (MTA)**: The minimum amount that can be transferred for any margin call. The amount is specified in the margining agreement.
8. **Collateral accrual**: All collateral cash balance pledged should earn accrued interest. The interest rate, tipically an overnight index, has to be defined and agreed.

Another way of collateral use in derivative markets is through a **Central Counterparty (CCP)**. The use of a central counterparty is mandatory for major banks in the US and Europe for certain types of derivative transactions. This requirement stems from international agreements and regulatory reforms following the global financial crisis of 2007-2008. In Chile, there's a CCP called *Comder*, although its use is optional.

### Model Setup: Funding and Collateral

We may think that the amount of cash borrowed or lent by a counterparty in the market is associated with a generic *funding account* $B_\alpha$, with value $B_\alpha (t)$ at time $t$. The index $\alpha$ will denote the specific source of funding.
In particular, we identify two sources of funding associated with interest rate derivatives:
- The generic funding (or treasury) account, denoted with $B_f$, associated with the standard (unsecured) money and bond market funding at rate $r_f$, typically Libor plus spread, operated by a trading desk through a treasury desk.
- The collateral account, denoted with $B_c$, associated with a collateral agreement at collateral rate $r_c$, typically overnight, operated by a trading desk through a collateral desk.

Let's assume the following dynamic of the funding account.

$$ dB_{\alpha}\left(t\right)=r_{\alpha}\left(t\right)B_{\alpha}\left(t\right) \, dt ,$$

$$ B_{\alpha}\left(0\right)=1 ,$$

$$ B_{\alpha}\left(t\right)=\exp\left( \int_{0}^{t}r_{\alpha}\left(u\right)du \right ), $$

where $r_\alpha(t)$ is the (short) funding interest rate, related to the cash amount $B_\alpha(t)$.

**Perfect CSA**

For pricing purposes it is useful to introduce an abstract ’perfect’ collateral agreement, characterized as follows.
- zero initial margin or initial deposit
- fully symmetric
- cash collateral
- zero threshold
- zero minimum transfer amount
- continuous margination
- instantaneous margination rate $r_c(t)$
- instantaneous settlement
- no collateral re-hypothecation by the collateral holder

As a consequence we have, in general,

$$ B_c(t) = \Pi(t), \forall t \leq T,$$

where $\Pi(t)$ is the value of the derivative portfolio associated to the CSA.

### Pricing Under Collateral

Pricing derivatives under collateral implies that we must take into account, other than the cash flows generated by the derivative, also the cash flows generated by the margination mechanism provided by the CSA. As a consequence, we must extend the basic no-arbitrage framework described in standard textbooks introducing the collateral account $B_c$ defined above, and the corresponding collateral cash flows generated by the margination mechanism. Here is the basic result, assuming that under perfect CSA the default of both counterparties is irrelevant, and there are no Credit/Debit Valuation Adjustments (CVA/DVA) to the value of the trade.

Let $\Pi$ be a derivative with maturity $T$ written on a single asset $X$ following the Geometric Brownian Motion process,

$$ dX\left(t\right)=\mu^P\left(t,X\right)X\left(t\right)dt+\sigma\left(t,X\right)X\left(t\right)dW^P\left(t\right) ,$$

$$ X\left(0\right)=X_0 ,$$

where $P$ is the real, or objective, probability measure. Assuming perfect collateral as defined above, the derivative's price at any time $t<T$ obeys the PDE

$$ \frac{\partial \,\Pi(t,X)}{\partial t}+r_f\left(t\right)X\left(t\right)\frac{\partial \,\Pi(t,X)}{\partial X}+\frac{1}{2}\sigma^2\left(t\right)X^2\left(t\right)\frac{\partial^2 \,\Pi(t,X)}{\partial X^2} - r_c(t) \,\Pi(t,X) = 0 ,$$

and is given by the expetaction 

$$ \Pi\left(t,X\right)=\mathbb{E}_t^{Q_f}\left[D_c\left(t,T\right)\cdot\Pi\left(T,X\right)\right] ,$$

$$ D_c\left(t,T\right)=\exp \left[- \int_t^T r_c \left( u \right) \, du \right] ,$$

where $Q_f$ is the probability measure associated with the funding account $B_f$ such that

$$ dX\left(t\right)=r_f\left(t\right)X\left(t\right)dt+\sigma\left(t,X\right)X\left(t\right)dW^{Q_f}\left(t\right). $$

Finally, we can say that the value of perfect collateralized derivative is obtained by discounting its payoff with a discount factor coming from the yield curve related with the collateral account.

**Change of measure: Forward**

It is useful to work on a measure in which the discount factor $D_c(t,T)$ can come out of the expected value. This is achieve with a change of measure (change of numeraire). The pricing expression

$$ \Pi\left(t,X\right)=P_c\left(t,T\right)\mathbb{E}_{t}^{Q_f^T}\left[\Pi\left(T,X\right)\right] ,$$

$$ P_c\left(t,T\right)=\mathbb{E}^{Q_f}\left[ D_c (t,T) \right] ,$$

holds, where $Q_f^T$ is the probability measure associated with the collateral zero coupon bond $P_c(t,T)$. This equation is the **general pricing formula for collateralized derivatives**.

## Yield Curves Bootstraping

### What's a Zero Rate and a Yield Curve?

**Zero rate**

A zero-coupon bond is an investment that pays \$1 in $T$ time. There are no intermediate payments. Thus, the zero rate is the interst rate used to discount this cashflow, or interchangeably, the rate of interest earned of such investment. The zero rates are usually continuously compounded and actual/365F.

**Yield curve or Term Structure**

The terms *Yield curve* and *Term structure* can be used interchangeably. The yield curve shows how the interest rates of bonds (or other fixed-income securities) vary with different maturity dates. Typically, these rates are plotted on a graph with the maturity length on the horizontal axis and the interest rate on the vertical axis. There are three type often used: 
- Zero curve: Already mentioned, it's a crucial tool for pricing and risk management.
- Forward curve: It's the implied rates by current zero rates for periods of time in the future. For example, the rate of a 1-year zero-coupon bond that starts in one year and ends in two.
- Discount curve: It's closely related to the zero-coupon yield curve but gives directly the discount factor rather than the yield.

**Zero-coupon Yield curve**

As seen above, the collateral rate is the right discount rate in case of perfect CSA. So, with this curve we can extract the discount factors and it's useful to estimate future rate values of rate indexes like overnights and Libors.

### Bootstrapping Method

It is a an iterative procedure in determining the rates of the curves at specific tenors, starting with the shortest one. Let's consider an overnight index





















## Reference
- Hull, John C., *Options, Futures, and Other Derivatives*. 11th ed., Pearson, 2021.
- Ametrano, Ferdinando M., and Marco Bianchetti. *Everything You Always Wanted to Know About Multiple Interest Rate Curve Bootstrapping but Were Afraid to Ask.* April 2, 2013. SSRN. https://ssrn.com/abstract=2219548 or http://dx.doi.org/10.2139/ssrn.2219548
- Deloitte. *Credit Support Annexure: Leveraging CSA for Collateralised Margining.* Risk Advisory, August 2018. PDF file. https://www2.deloitte.com/content/dam/Deloitte/in/Documents/risk/POV_CSA_V11_1067_att_st_Brand(29-08-18).pdf.
- Henrard, Marc P. A. *Interest Rate Instruments and Market Conventions Guide.* First Edition. OpenGamma Quantitative Research, April 2012. SSRN. https://ssrn.com/abstract=2128257.
