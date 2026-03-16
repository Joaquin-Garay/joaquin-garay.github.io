---
layout: post
author: Joaquin Garay
title: "Hierarchical Mixture Models and Their EM Algorithm"
date: 2026-03-16
categories: [machine-learning, statistics, EM]
---

## Background

The Expectation-Maximization (EM) algorithm is a well-studied method for learning parameters by maximizing the data likelihood when the model contains latent or missing variables. This is the most common loss function for the family of latent-variable models. It can be derived from a variational argument, as explained in Bishop's *Pattern Recognition and Machine Learning* and many other sources.

Consider a mixture distribution:

$$
p_{\boldsymbol{\Theta}}(\mathbf{x}) = \sum_{i=1}^K \pi_i \,f(\mathbf{x};\boldsymbol{\theta}_i),
\qquad
\sum_{i=1}^K \pi_i = 1.
$$

The key idea is to view the mixture as the marginal of a joint model with a latent categorical variable \(Y\):
\(p(\mathbf{x}) = \sum_i p(y=i)\, p(\mathbf{x}\mid y=i)\), with \(Y\sim \text{Cat}(\boldsymbol{\pi})\).

Instead of maximizing \(p_{\boldsymbol{\Theta}}(\mathbf{x})\) directly, we maximize the so-called evidence lower bound (ELBO) iteratively:

$$
\log p_{\boldsymbol{\Theta}}(\mathbf{x})
\ge
\mathcal{L}(\boldsymbol{\Theta}, \boldsymbol{\Theta}^{old})
:=
\mathbb{E}_{Y\mid X,\boldsymbol{\Theta}^{old}}
\left[\log p_{\boldsymbol{\Theta}}(\mathbf{x},y)\right]
+ \text{constant independent of } \boldsymbol{\Theta}.
$$

In the case of mixture models, the lower bound is a conditional expectation of the complete-data log likelihood \(p_{\boldsymbol{\Theta}}(\mathbf{x},y)\). The EM algorithm proceeds as follows:

- **E-Step (Compute the expectation):** We need the posterior distribution inside that expectation, \(p_{\boldsymbol{\Theta}^{old}}(y\mid \mathbf{x})\) for all \(y\in\{1,\dots,K\}\), usually referred to as the responsibilities \(r_{n,i}\). By Bayes rule: \(p(y\mid \mathbf{x}) = p(y)p(\mathbf{x}\mid y)/p(\mathbf{x})\).
- **M-Step (Maximize the expectation):** Once we have that posterior law, we maximize over \(\boldsymbol{\Theta}\).

## Hierarchical Mixture Model

Now suppose \(\mathbf{x}\) splits into two feature blocks \(\mathbf{x}:=(\mathbf{x}_1,\mathbf{x}_2)\), and we want to build a second layer of mixtures using \(\mathbf{x}_2\) on top of the existing mixture model that receives \(\mathbf{x}_1\). Each first-layer component \(f(\mathbf{x}_1;\boldsymbol{\theta}_i)\) is paired with a second mixture model built from the features \(\mathbf{x}_2\):

$$
p_{\boldsymbol{\Theta}}(\mathbf{x})
=
\sum_{i=1}^K
\pi_i \,f(\mathbf{x}_1;\boldsymbol{\theta}_i)\,p_{\Theta_i}(\mathbf{x}_2)
=
\sum_{i=1}^K
\pi_i \,f(\mathbf{x}_1;\boldsymbol{\theta}_i)
\sum_{j=1}^{K_i} \pi_{ij}\,h(\mathbf{x}_2;\boldsymbol{\theta}_{ij}).
$$

Note that \(\mathbf{x}_1 \perp \mathbf{x}_2\) within the \(i\)-th component, but they are not unconditionally independent. How do we train such a model? What modifications are needed in EM?

To model this hierarchy, introduce two latent discrete variables: \(Y\) for the first layer and \(Z\) for the second. Then we can separate the expectation of the complete-data log likelihood into two iterated expectations:

$$
\mathbb{E}_{Y,Z\mid X,\boldsymbol{\Theta}^{old}}
\left[\log p_{\boldsymbol{\Theta}}(\mathbf{x},y,z)\right]
=
\mathbb{E}_{Y\mid X,\boldsymbol{\Theta}^{old}}
\left[
\mathbb{E}_{Z\mid X,Y,\boldsymbol{\Theta}^{old}}
\left[\log p_{\boldsymbol{\Theta}}(\mathbf{x},y,z)\right]
\right].
$$

This is the key point: the E-step inherits the same hierarchy as the model itself. Two layers of posterior distributions:

$$
p(y\mid\mathbf{x}) = \frac{p(y)p(\mathbf{x}\mid y)}{p(\mathbf{x})},
\qquad
p(z\mid y,\mathbf{x}) = \frac{p(z\mid y)\,p(\mathbf{x}\mid y,z)}{p(\mathbf{x}\mid y)}.
$$

Take a closer look at these quantities. \(y\) (categorical support) represents first-layer components as usual, and \(z\mid y\) the second-layer ones. Assuming \((z \perp \mathbf{x}_1 \mid y)\) and \((\mathbf{x}_2 \perp \mathbf{x}_1 \mid y)\), then:

$$
\begin{aligned}
p(\mathbf{x}_1,\mathbf{x}_2)
&= \sum_y p(\mathbf{x}_1,\mathbf{x}_2\mid y)\,p(y) \\
&= \sum_y p(\mathbf{x}_2\mid \mathbf{x}_1,y)\,p(\mathbf{x}_1\mid y)\,p(y) \\
&= \sum_y \left(\sum_{z\mid y} p(\mathbf{x}_2\mid y,z)\,p(z\mid y)\right)\,p(\mathbf{x}_1\mid y)\,p(y).
\end{aligned}
$$

So the posterior probabilities can be decomposed as:

$$
\begin{aligned}
r_{n,i}^{(1)}
&:= p(y=i\mid \mathbf{x}_n) \\
&= \frac{
\pi_i f(\mathbf{x}_{1,n};\boldsymbol{\theta}_i)
\sum_{j=1}^{K_i}\pi_{ij}h(\mathbf{x}_{2,n};\boldsymbol{\theta}_{ij})
}{
\sum_{i'=1}^{K}\pi_{i'} f(\mathbf{x}_{1,n};\boldsymbol{\theta}_{i'})
\sum_{j'=1}^{K_{i'}}\pi_{i'j'}h(\mathbf{x}_{2,n};\boldsymbol{\theta}_{i'j'})
},
\\[1em]
r_{n,i,j}^{(2)}
&:= p(z=j\mid y=i,\mathbf{x}_n) \\
&= \frac{
\pi_{ij} h(\mathbf{x}_{2,n};\boldsymbol{\theta}_{ij})
}{
\sum_{j'=1}^{K_i}\pi_{ij'} h(\mathbf{x}_{2,n};\boldsymbol{\theta}_{ij'})
}.
\end{aligned}
$$

Note that some factors of
\(p_{\boldsymbol{\Theta}}(\mathbf{x}_1,\mathbf{x}_2,y,z) = p(y)p(\mathbf{x}_1\mid y)\cdot p(z\mid y)p(\mathbf{x}_2\mid y,z)\)
are constant with respect to the inner expectation, so we can simplify the M-step:

$$
\sum_n \mathbb{E}\left[\log p(\mathbf{x}_n,y,z)\right]
=
\sum_{n,i}
r_{n,i}^{(1)}
\left[\log \pi_i + \log f(\mathbf{x}_{1,n};\boldsymbol{\theta}_i)\right]
+
\sum_{n,i,j}
r_{n,i}^{(1)}r_{n,i,j}^{(2)}
\left[\log \pi_{ij} + \log h(\mathbf{x}_{2,n};\boldsymbol{\theta}_{ij})\right].
$$

The main takeaway is that second-layer updates are weighted EM updates, where the weights are the first-layer responsibilities.

## Algorithm 1: EM for Mixture Models

```text
Input: data {x_n}_{n=1}^N
Initialize parameters {π_i, θ_i}_{i=1}^K

Repeat until convergence:
  E-step:
    For n = 1..N, i = 1..K
      r_{n,i} <- [π_i f(x_n; θ_i)] / [Σ_{i'=1}^K π_{i'} f(x_n; θ_{i'})]

  M-step:
    For i = 1..K
      π_i <- (1/N) Σ_{n=1}^N r_{n,i}
      θ_i <- argmax_θ Σ_{n=1}^N r_{n,i} log f(x_n; θ)

Return {π_i, θ_i}_{i=1}^K
```

## Algorithm 2: EM for Two-Layer Hierarchical Mixture Models

```text
Input: data {x_n}_{n=1}^N, with x_n = (x_{1,n}, x_{2,n})
Initialize first-layer parameters {π_i, θ_i}_{i=1}^K
Initialize second-layer parameters {π_{ij}, θ_{ij}} for i=1..K, j=1..K_i

Repeat until convergence:
  E-step:
    For n = 1..N, i = 1..K
      r^{(1)}_{n,i} <- [π_i f(x_{1,n}; θ_i) Σ_{j=1}^{K_i} π_{ij} h(x_{2,n}; θ_{ij})]
                     / [Σ_{i'=1}^K π_{i'} f(x_{1,n}; θ_{i'}) Σ_{j'=1}^{K_{i'}} π_{i'j'} h(x_{2,n}; θ_{i'j'})]

      For j = 1..K_i
        r^{(2)}_{n,i,j} <- [π_{ij} h(x_{2,n}; θ_{ij})]
                          / [Σ_{j'=1}^{K_i} π_{ij'} h(x_{2,n}; θ_{ij'})]

  M-step:
    For i = 1..K
      π_i <- (1/N) Σ_{n=1}^N r^{(1)}_{n,i}
      θ_i <- argmax_θ Σ_{n=1}^N r^{(1)}_{n,i} log f(x_{1,n}; θ)

      For j = 1..K_i
        π_{ij} <- [Σ_{n=1}^N r^{(1)}_{n,i} r^{(2)}_{n,i,j}] / [Σ_{n=1}^N r^{(1)}_{n,i}]
        θ_{ij} <- argmax_θ Σ_{n=1}^N r^{(1)}_{n,i} r^{(2)}_{n,i,j} log h(x_{2,n}; θ)

Return {π_i, θ_i}_{i=1}^K and {π_{ij}, θ_{ij}} for i=1..K, j=1..K_i
```
