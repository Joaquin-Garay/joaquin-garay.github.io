---
layout: post
author: Joaquin Garay
title: "Finite Difference Option Pricing"
date: 2025-04-16
categories: [finance, finite-difference, FDM]
---

## American Options and Finite Difference Method  
**Joaquin Garay**  

_As part of the course FRE 6233: Stochastic Calculus and Option Pricing_

### Purpose

We consider an American put option with strike price $K$ and maturity $T$ under the Black‑Scholes framework. The underlying asset price $S_t$ is assumed to follow a geometric Brownian motion under the risk‑neutral measure $\mathbb{Q}$, described by the stochastic differential equation:

$$
dS_t = r\,S_t\,dt + \sigma\,S_t\,dW_t
$$

where $r$ is the risk‑free rate, $\sigma$ the volatility, and $W_t$ a standard Brownian motion under $\mathbb{Q}$.

Our objective is to compute the value of the American put and determine the early‑exercise boundary using the Finite Difference Method (FDM).

---

### Setup

The Finite Difference Method is a numerical technique for solving partial differential equations (PDEs). It discretizes time and space, converting the continuous PDE into a system of algebraic equations that we solve iteratively.

In option pricing, FDM lets us step backward in time and enforce the free‑boundary (early exercise) condition at each slice.

The Obstacle PDE reads:

$$
\min\!\big\{
\,\frac{\partial u(x,\tau)}{\partial \tau}
- (r-\delta)x\,\frac{\partial u(x,\tau)}{\partial x}
- \tfrac12\,\sigma^2 x^2\,\frac{\partial^2 u(x,\tau)}{\partial x^2}
+ r\,u(x,\tau),
\;u(x,\tau)\,-\,(K-x)_+
\big\}
= 0,
\quad
\forall\,\tau\in(0,T],\;x\ge0
$$

where $\tau=T-t$ is time to maturity.

---

#### The Mesh

Using an implicit scheme, the “continuation” part of the PDE becomes:

$$
\frac{u_i^{n+1}-u_i^n}{\Delta t}
- (r-\delta)x_i\,\frac{u_{i+1}^{n+1}-u_i^{n+1}}{\Delta x}
- \tfrac12\,\sigma^2 x_i^2\,\frac{u_{i-1}^{n+1}-2u_i^{n+1}+u_{i+1}^{n+1}}{(\Delta x)^2}
+ r\,u_i^{n+1}
= 0
$$

Although only first‑order accurate, this scheme is unconditionally monotone and thus converges locally uniformly to the true solution (Barles–Souganidis Theorem):

$$
u_i^n
= u_{i-1}^{n+1}\underbrace{\bigl(-\tfrac12\,\tfrac{\Delta t}{(\Delta x)^2}\,\sigma^2 x_i^2\bigr)}_{a_i}
+ u_i^{n+1}\underbrace{\bigl(1
  + \tfrac{\Delta t}{\Delta x}(r-\delta)x_i
  + \tfrac{\Delta t}{(\Delta x)^2}\,\sigma^2 x_i^2
  + r\,\Delta t
\bigr)}_{b_i}
+ u_{i+1}^{n+1}\underbrace{\bigl(-\tfrac{\Delta t}{\Delta x}(r-\delta)x_i
  - \tfrac12\,\tfrac{\Delta t}{(\Delta x)^2}\,\sigma^2 x_i^2
\bigr)}_{c_i}
$$

---

#### Matrix Form

$$
A_h\,\mathbf{u}_h^{n+1} \;=\; \mathbf{u}_h^n,
\qquad
\mathbf{u}_h^n = 
\begin{bmatrix}
\vdots\\
u_{i-1}^n\\
u_i^n\\
u_{i+1}^n\\
\vdots
\end{bmatrix},
\quad
A_h = 
\begin{bmatrix}
b_0 & c_0 &      &      &   \\
\cdot & \cdot & \cdot &      &   \\
      & \cdot & \cdot & \cdot &   \\
      &  a_i  &  b_i  &  c_i  &   \\
      &       & \cdot & \cdot & \cdot\\
      &       &       & a_M   & b_M
\end{bmatrix}
$$

We use a uniform mesh of $M+1$ price‑nodes and $N+1$ time‑steps.

---

#### Boundary Conditions

Price is truncated at $x^*$, where

$$
x^* = S_0 \exp\!\bigl((r-\tfrac12\,\sigma^2)T + 3\sigma\sqrt{T}\bigr).
$$

We impose
- $u(\tau,0)=K$
- $u(\tau,x^*)=0\quad\forall\,\tau$

so

$$
\mathbf{u}_h^n = [\,K,\dots,u_{i-1}^{n},u_i^{n},u_{i+1}^{n},\dots,0\,]^\top,
\quad
b_0=1,\;c_0=0,\;a_M=0,\;b_M=0.
$$

---

#### Inverse of Matrix $A$

We solve $A\,x=b$ via the Thomas algorithm (specialized Gaussian elimination for tridiagonal systems).


#### Code Parameters


