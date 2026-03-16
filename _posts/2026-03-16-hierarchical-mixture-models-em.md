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
p_{\pmb{\Theta}}(\mathbf{x}) = \sum_{i=1}^K \pi_i \,f(\mathbf{x};\pmb{\theta}_i),
\qquad \sum_{i=1}^K \pi_i = 1.
$$

The key idea is to view the mixture as the marginal of a joint model with a latent categorical variable $Y$:
$p(\mathbf{x}) = \sum_i p(y=i)\, p(\mathbf{x}\mid y=i)$, with $Y\sim \text{Cat}(\pmb{\pi})$.

Instead of maximizing $p_{\pmb{\Theta}}(\mathbf{x})$ directly, we maximize the so-called evidence lower bound (ELBO) iteratively:

$$ 
\log p_{\pmb{\Theta}}(\mathbf{x})
\ge
\mathcal{L}(\pmb{\Theta}, \pmb{\Theta}^{old})
:=
\mathbb{E}_{Y\mid X,\pmb{\Theta}^{old}}
\left[\log p_{\pmb{\Theta}}(\mathbf{x},y)\right] + 
\text{constant independent of } \pmb{\Theta}. 
$$

In the case of mixture models, the lower bound is a conditional expectation of the complete-data log likelihood $p_{\pmb{\Theta}}(\mathbf{x},y)$. The EM algorithm proceeds as follows:

- **E-Step (Compute the expectation):** We need the posterior distribution inside that expectation, $p_{\pmb{\Theta}^{old}}(y\mid \mathbf{x})$ for all $y\in\{1,\dots,K\}$, usually referred to as the responsibilities $r_{n,i}$. By Bayes rule: $p(y\mid \mathbf{x}) = p(y)p(\mathbf{x}\mid y)/p(\mathbf{x})$.
- **M-Step (Maximize the expectation):** Once we have that posterior law, we maximize over $\pmb{\Theta}$.

## Hierarchical Mixture Model

Now suppose $\mathbf{x}$ splits into two feature blocks $\mathbf{x}:=(\mathbf{x}_1,\mathbf{x}_2)$, and we want to build a second layer of mixtures using $\mathbf{x}_2$ on top of the existing mixture model that receives $\mathbf{x}_1$. Each first-layer component $f(\mathbf{x}_1;\pmb{\theta}_i)$ is paired with a second mixture model built from the features $\mathbf{x}_2$:

$$
p_{\pmb{\Theta}}(\mathbf{x})
=
\sum_{i=1}^K
\pi_i \,f(\mathbf{x}_1;\pmb{\theta}_i)\,p_{\Theta_i}(\mathbf{x}_2)
=
\sum_{i=1}^K
\pi_i \,f(\mathbf{x}_1;\pmb{\theta}_i)
\sum_{j=1}^{K_i} \pi_{ij}\,h(\mathbf{x}_2;\pmb{\theta}_{ij}).
$$

Note that $\mathbf{x}_1 \perp \mathbf{x}_2$ within the $i$-th component, but they are not unconditionally independent. How do we train such a model? What modifications are needed in EM?

To model this hierarchy, introduce two latent discrete variables: $Y$ for the first layer and $Z$ for the second. Then we can separate the expectation of the complete-data log likelihood into two iterated expectations:

$$
\mathbb{E}_{Y,Z\mid X,\pmb{\Theta}^{old}}
\left[\log p_{\pmb{\Theta}}(\mathbf{x},y,z)\right]
=
\mathbb{E}_{Y\mid X,\pmb{\Theta}^{old}}
\left[
\mathbb{E}_{Z\mid X,Y,\pmb{\Theta}^{old}}
\left[\log p_{\pmb{\Theta}}(\mathbf{x},y,z)\right]
\right].
$$

This is the key point: the E-step inherits the same hierarchy as the model itself. Two layers of posterior distributions:

$$
p(y\mid\mathbf{x}) = \frac{p(y)p(\mathbf{x}\mid y)}{p(\mathbf{x})},
\qquad
p(z\mid y,\mathbf{x}) = \frac{p(z\mid y)\,p(\mathbf{x}\mid y,z)}{p(\mathbf{x}\mid y)}.
$$

Take a closer look at these quantities. $y$ (categorical support) represents first-layer components as usual, and $z\mid y$ the second-layer ones. Assuming $(z \perp \mathbf{x}_1 \mid y)$ and $(\mathbf{x}_2 \perp \mathbf{x}_1 \mid y)$, then:

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
\pi_i f(\mathbf{x}_{1,n};\pmb{\theta}_i)
\sum_{j=1}^{K_i}\pi_{ij}h(\mathbf{x}_{2,n};\pmb{\theta}_{ij})
}{
\sum_{i'=1}^{K}\pi_{i'} f(\mathbf{x}_{1,n};\pmb{\theta}_{i'})
\sum_{j'=1}^{K_{i'}}\pi_{i'j'}h(\mathbf{x}_{2,n};\pmb{\theta}_{i'j'})
},
\\[1em]
r_{n,i,j}^{(2)}
&:= p(z=j\mid y=i,\mathbf{x}_n) \\
&= \frac{
\pi_{ij} h(\mathbf{x}_{2,n};\pmb{\theta}_{ij})
}{
\sum_{j'=1}^{K_i}\pi_{ij'} h(\mathbf{x}_{2,n};\pmb{\theta}_{ij'})
}.
\end{aligned}
$$

Note that some factors of
$p_{\pmb{\Theta}}(\mathbf{x}_1,\mathbf{x}_2,y,z) = p(y)p(\mathbf{x}_1\mid y)\cdot p(z\mid y)p(\mathbf{x}_2\mid y,z)$
are constant with respect to the inner expectation, so we can simplify the M-step:

$$
\sum_n \mathbb{E}\left[\log p(\mathbf{x}_n,y,z)\right]
=
\sum_{n,i}
r_{n,i}^{(1)}
\left[\log \pi_i + \log f(\mathbf{x}_{1,n};\pmb{\theta}_i)\right] +
\sum_{n,i,j}
r_{n,i}^{(1)}\,r_{n,i,j}^{(2)}
\left[\log \pi_{ij} + \log h(\mathbf{x}_{2,n};\pmb{\theta}_{ij})\right].
$$

The main takeaway is that second-layer updates are weighted EM updates, where the weights are the first-layer responsibilities.

## Algorithm 1: EM for Mixture Models

$$
\begin{aligned}
& \text{Input: data } \{x_n\}_{n=1}^N & \qquad\qquad & \qquad\qquad & \qquad\qquad & \qquad\qquad\\ 
& \text{Initialize parameters } \{\pi_i, \pmb{\theta}_i\}_{i=1}^K & \\
& \text{Repeat until convergence:} \\
& \qquad\textbf{E-step:} \\
& \qquad\text{for } n \,\text{ in } 1..N, \, i \,\text{ in } 1..K: & \\
& \qquad\qquad r_{n,i} \leftarrow \frac{\pi_i \, p(\mathbf{x}_n;\pmb{\theta}_i)}{\sum_{i'} \pi_{i'} \, p(\mathbf{x}_{i'};\pmb{\theta}_{i'})} \\
& \qquad\textbf{M-step:} \\
& \qquad\text{for } i \,\text{ in } 1..K: & \\
& \qquad\qquad \pi_i \leftarrow \frac{1}{N}\sum_i r_{n,i}  \\
& \qquad\qquad \pmb{\theta}_i \leftarrow \text{argmax}_{\pmb{\theta}} \sum_{n=1}^N r_{n,i}\,\log f(\mathbf{x}_n;\pmb{\theta})  
\end{aligned}
$$

## Algorithm 2: EM for Two-Layer Hierarchical Mixture Models

$$
\begin{aligned}
& \text{Input: data } \{\mathbf{x}_n\}_{n=1}^N,\; \mathbf{x}_n=(\mathbf{x}_{1,n},\mathbf{x}_{2,n}) & \qquad\qquad & \qquad\qquad & \qquad \\ 
& \text{Initialize first-layer parameters } \{\pi_i, \pmb{\theta}_i\}_{i=1}^K & \\
& \text{Initialize second-layer parameters } \{\pi_{ij}, \pmb{\theta}_{ij}\}_{(i,j)=(1,1)}^{(K,K_i)} & \\
& \text{Repeat until convergence:} \\
& \qquad\textbf{E-step:} \\
& \qquad\text{for } n \,\text{ in } 1..N, \, i \,\text{ in } 1..K: & \\
& \qquad\qquad r_{n,i}^{(1)} \leftarrow \frac{\pi_i f(\mathbf{x}_{1,n};\pmb{\theta}_i)\sum_{j=1}^{K_i}\pi_{ij}h(\mathbf{x}_{2,n};\pmb{\theta}_{ij})}{\sum_{i'=1}^{K}\pi_{i'}f(\mathbf{x}_{1,n};\pmb{\theta}_{i'})\sum_{j'=1}^{K_{i'}}\pi_{i'j'}h(\mathbf{x}_{2,n};\pmb{\theta}_{i'j'})} \\
& \qquad\qquad\text{for } j \,\text{ in } 1..K_i: & \\
& \qquad\qquad\qquad r_{n,i,j}^{(2)} \leftarrow \frac{\pi_{ij}h(\mathbf{x}_{2,n};\pmb{\theta}_{ij})}{\sum_{j'=1}^{K_i}\pi_{ij'}h(\mathbf{x}_{2,n};\pmb{\theta}_{ij'})} \\
& \qquad\textbf{M-step:} \\
& \qquad\text{for } i \,\text{ in } 1..K: & \\
& \qquad\qquad \pi_i \leftarrow \frac{1}{N}\sum_{n=1}^N r_{n,i}^{(1)} \\
& \qquad\qquad \pmb{\theta}_i \leftarrow \text{argmax}_{\pmb{\theta}} \sum_{n=1}^N r_{n,i}^{(1)}\log f(\mathbf{x}_{1,n};\pmb{\theta}) \\
& \qquad\qquad\text{for } j \,\text{ in } 1..K_i: & \\
& \qquad\qquad\qquad \pi_{ij} \leftarrow \frac{\sum_{n=1}^N r_{n,i}^{(1)}r_{n,i,j}^{(2)}}{\sum_{n=1}^N r_{n,i}^{(1)}} \\
& \qquad\qquad\qquad \pmb{\theta}_{ij} \leftarrow \text{argmax}_{\pmb{\theta}} \sum_{n=1}^N r_{n,i}^{(1)}r_{n,i,j}^{(2)}\log h(\mathbf{x}_{2,n};\pmb{\theta})
\end{aligned}
$$


