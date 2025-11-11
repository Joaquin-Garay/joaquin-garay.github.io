---
layout: post
author: Joaquin Garay
title: "My NYU Ms Financial Engineering Course Review"
date: 2025-10-28
categories: [MSFE]
description: Honest, course-by-course notes on NYU Tandon’s MSFE from a quant-focused track — difficulty ratings reflect conceptual complexity, not grading stringency.
---

I’m sharing a course-by-course look at NYU Tandon’s MS in Financial Engineering because syllabi often don’t capture what a class *feels* like in practice. Everything here reflects my personal experience.

> **Difficulty legend:** Conceptual difficulty (how hard it was to *understand the material*), **not** how hard it was to earn a grade.

### My track
Thanks to prior work in quantitative finance, I waived two core courses (Quantitative Methods and Intro to Derivatives), so I ended up designing my track with focus in two areas, which are statistical learning and stochastic modeling. I took almost none financial courses because the opportunity cost of quiting other interesting courses was too much.

- **Fall 2024 (9 c):** `FRE-7773` Machine Learning, `FRE-6103` Valuation, `FRE-6123` Risk Management  
- **Spring 2025 (12 c):** `FRE-6233` Stochastic Calculus, `FRE-6883` C++, `FRE-7821` Optimal Control, `FRE-6901` Volatility Models, `FRE-9053` Information Geometry  
- **Fall 2025 (9 c):** `MATH-2047` Trends in Financial Data Science, `FRE-7251` Algorithmic Trading, `FRE-7841` Hedge Fund Strategies, `FRE-6803` Independent Research  
- **Spring 2026 (3 c):** MS Thesis

### Jump to a course
[FRE-7773](#fre-7773--machine-learning-in-financial-engineering) ·
[FRE-6123](#fre-6123--financial-risk-management) ·
[FRE-6103](#fre-6103--valuation-for-financial-engineering) ·
[FRE-6233](#fre-6233--option-pricing-and-stochastic-calculus) ·
[FRE-6883](#fre-6883--financial-computing-c) ·
[FRE-7821](#fre-7821--stochastic-optimal-control) ·
[FRE-9053](#fre-9053--information-geometry) ·
[FRE-6901](#fre-6901--volatility-models) ·
[MATH-2047](#math-2047--trends-in-financial-data-science) ·
[FRE-7251](#fre-7251--algorithmic-trading-and-high-frequency-finance) ·
[FRE-7841](#fre-7841--hedge-fund-strategies)

---

## Summary at a glance

| Term       | Course & Code | Professor | Difficulty |
|------------|----------------|-----------|-----------|
| Fall 2024  | Machine Learning — `FRE-7773` | Amine Aboussalah | ★★☆☆☆ (2/5) |
| Fall 2024  | Financial Risk Management — `FRE-6123` | James Adams | ★★☆☆☆ (2/5) |
| Fall 2024  | Valuation for FE — `FRE-6103` | David Shimko | ★★☆☆☆ (2/5) |
| Spring 2025| Option Pricing & Stochastic Calculus — `FRE-6233` | Agnès Tourin | ★★★☆☆ (3/5) |
| Spring 2025| Financial Computing (C++) — `FRE-6883` | Song Tang | ★★☆☆☆ (2/5) |
| Spring 2025| Stochastic Optimal Control — `FRE-7821` | Nizar Touzi | ★★★★☆ (4/5) |
| Spring 2025| Information Geometry — `FRE-9053` | Amine Aboussalah | ★★★★☆ (4/5) |
| Spring 2025| Volatility Models — `FRE-6901` | Julien Guyon | ★★★★★ (5/5) |
| Fall 2025  | Trends in Financial Data Science — `MATH-2047` | Ivailo Dimov & Florian Bourgey | ★★★★★ (5/5) |
| Fall 2025  | Algorithmic Trading & HFF — `FRE-7251` | Alec Schmidt | ★☆☆☆☆ (1/5) |
| Fall 2025  | Hedge Fund Strategies — `FRE-7841` | James Conklin | ★☆☆☆☆ (1/5)  |

---

## FRE-7773 — Machine Learning in Financial Engineering
- **Professor:** Amine Aboussalah  
- **Difficulty:** ★★☆☆☆ (2/5)
- **Term:** Fall 2024

The course was design to teach the fundamentals of the basic building-block models in machine learning. Focused on the math of the algorithms in detail rather than practical applications (Python code using some libraries), which by the way I liked very much because is easier to learn a specific library API once you know what the model is doing behind rather than the other way around.

Slides were sent as readings and the lecture was pure whiteboard writing, old-school style. Because Prof. Amine was trying a new course design (I think) the assessment schedule was a bit messy but that should have little relevance if you are there for learning.


## FRE-6123 — Financial Risk Management
- **Professor:** James Adams  
- **Difficulty:** ★★☆☆☆ (2/5)
- **Term:** Fall 2024

This is the best-designed course I've ever taken. It follows the GARP program with four core topics: Market risk, Credit risk, Operational risk, and Asset Liability Management. It gives a great overview of the financial and banking system: Broad scope with little depth is specially useful for students with no financial background. Prof. Adams is a CFA member so the homeworks and exams definitely have that flavor.


## FRE-6103 — Valuation for Financial Engineering
- **Professor:** David Shimko  
- **Difficulty:** ★★☆☆☆ (2/5)
- **Term:** Fall 2024

## FRE-6233 — Option Pricing and Stochastic Calculus
- **Professor:** Agnès Tourin  
- **Difficulty:** ★★★☆☆ (3/5)
- **Term:** Spring 2025

I think a course covering applied stochastic calculus is almost mandatory for any MsFE program. This is mostly based on the great book *Stochastic Calculus for Finance II* by S. Shreve, going through all chapters except for Ch. 9 Change of Measure and Ch. 10 Term Structure Models, even though those were mildly included from different sources. Also the Finite Difference Method was incorporated as a numerical solver for American options although the course is mainly theoretical math with a lot of problem sets.

## FRE-6883 — Financial Computing (C++)
- **Professor:** Song Tang  
- **Difficulty:** ★★☆☆☆ (2/5)
- **Term:** Spring 2025

The famous C++ course of the program. 75% of it is devoted to learn the basics of C++ (Pointers, references, classes, polymorphism, memory allocation, etc.) while building an option pricer, so each week you are adding more features to a module and learning the language on the way. It could feel basic if you have already a background in C++, and the last 25% of the course dedicated to financial computing could not be worth the 3 credits if this is the case. For me was completely new, and I was satisfied with the teaching style of Prof. Tang.

## FRE-7821 — Stochastic Optimal Control
- **Professor:** Nizar Touzi  
- **Difficulty:** ★★★★☆ (4/5)
- **Term:** Spring 2025

This is the first 7 weeks of a PhD-level course on Stochastic Control, where you learn the Feymann-Kac Theorem, Dynamic Programming Principle and Hamilton-Jacobi-Bellman Equation in full detail. It's not an easy course, and could be scary with a weak math background, but Prof. Nizar will take care of you. There's no graded homework or exam, just one project where you need to explain a paper, for example for Masters students, there's a bunch of variations of the Merton problem that are suitable for the course.

## FRE-9053 — Information Geometry
- **Professor:** Amine Aboussalah  
- **Difficulty:** ★★★★☆ (4/5)
- **Term:** Spring 2025

## FRE-6901 — Volatility Models
- **Professor:** Julien Guyon  
- **Difficulty:** ★★★★★ (5/5)
- **Term:** Spring 2025

## MATH-2047 — Trends in Financial Data Science
- **Professors:** Ivailo Dimov & Florian Bourgey  
- **Difficulty:** ★★★★★ (5/5)
- **Term:** Fall 2025

A mathematical course about Bayesian models, covering a broad range of latent-variable methods. The course starts with Bayesian linear regression, Black–Litterman from a Bayesian perspective, Singular Value Decomposition for PCA and ICA, probabilistic PCA, Kalman filters and Hidden Markov Models, mixture models, Gaussian processes, and more. Lectures are accompanied by short demonstrations of financial applications of these models.

Expect **a lot** of linear algebra and a background in stochastic calculus and machine learning is definitely advisable.

## FRE-7251 — Algorithmic Trading and High-Frequency Finance
- **Professor:** Alec Schmidt  
- **Difficulty:** ★☆☆☆☆ (1/5)
- **Term:** Fall 2025

Calling this course algo trading would be a misnomer. It's a course about fundamentals of trading, exploring some technical analysis strategies along some microstructure/LOB models. Since there are only 6 lectures, of course, topics cannot be covered in depth.

## FRE-7841 — Hedge Fund Strategies
- **Professor:** James Conklin  
- **Difficulty:** ★☆☆☆☆ (1/5)
- **Term:** Fall 2025

And Excel-based course of portfolio management. I haven't finished it, but it seems like a nice and chill course.

---

*Last updated: 2025-10-28.*
