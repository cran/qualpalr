// The distance matrix algorithm has been adopted from
// http://gallery.rcpp.org/articles/parallel-distance-matrix/ and is copyrighted
// to JJ Allaire and Jim Bullard 2014 under GPL-2. The code has been altered
// from its original form.

#include <RcppArmadillo.h>
// #include <armadillo>

// template<typename InputIterator1, typename InputIterator2>
// inline double
// euclid(InputIterator1 begin1,
//        InputIterator1 end1,
//        InputIterator2 begin2,
//        InputIterator2 end2)
// {
//   double out = 0;
//
//   InputIterator1 it1 = begin1;
//   InputIterator2 it2 = begin2;
//
//   while (it1 != end1)
//     out += std::pow(*it1++ - *it2++, 2);
//
//   return std::pow(std::sqrt(out), 0.74) * 1.28;
// }
//
// struct dist_worker : public RcppParallel::Worker
// {
//   const RcppParallel::RMatrix<double> mat;
//   RcppParallel::RMatrix<double> rmat;
//   dist_worker(const Rcpp::NumericMatrix mat, Rcpp::NumericMatrix rmat)
//     : mat(mat)
//     , rmat(rmat)
//   {
//   }
//
//   void operator()(std::size_t begin, std::size_t end)
//   {
//     for (std::size_t i = begin; i < end; i++) {
//       for (std::size_t j = 0; j < i; j++) {
//         RcppParallel::RMatrix<double>::Row row1 = mat.row(i);
//         RcppParallel::RMatrix<double>::Row row2 = mat.row(j);
//         double d = euclid(row1.begin(), row1.end(), row2.begin(),
//         row2.end()); rmat(i, j) = d; rmat(j, i) = d;
//       }
//     }
//   }
// };

// [[Rcpp::export]]
arma::mat
edist(const arma::mat& x)
{
  const int n = x.n_rows;
  const arma::mat x_t = x.t();
  arma::mat result(n, n);

  for (int i = 0; i < n; ++i) {
    for (int j = i; j < n; ++j) {
      double d = arma::norm(x_t.col(i) - x_t.col(j), 2);
      d = std::pow(d, 0.74) * 1.28;
      result(i, j) = d;
      result(j, i) = d;
    }
  }

  return result;
}

arma::uvec
std_setdiff(const arma::uvec& x, const arma::uvec& y)
{
  std::vector<int> a = arma::conv_to<std::vector<int>>::from(arma::sort(x));
  std::vector<int> b = arma::conv_to<std::vector<int>>::from(arma::sort(y));
  std::vector<int> out;

  std::set_difference(
    a.begin(), a.end(), b.begin(), b.end(), std::inserter(out, out.end()));

  return arma::conv_to<arma::uvec>::from(out);
}

// Farthest point optimization

// [[Rcpp::export]]
arma::uvec
farthest_points(const arma::mat& data, const arma::uword n)
{
  arma::mat dm = edist(data);
  arma::uword N = dm.n_cols;

  arma::uvec full_range = arma::linspace<arma::uvec>(0, N - 1, N);
  arma::uvec r = arma::linspace<arma::uvec>(0, N - 1, n);
  arma::uvec r_old(n);

  do {
    r_old = r;
    for (arma::uword i = 0; i < n; ++i) {
      arma::uvec::fixed<1> ri;

      ri.fill(r(i));

      arma::uvec incl = std_setdiff(r, ri);
      arma::uvec excl = std_setdiff(full_range, incl);
      arma::uvec indices = full_range(excl);
      arma::rowvec mins = arma::min(dm.submat(incl, excl), 0);
      r(i) = indices(mins.index_max());
    }
  } while (!all(r_old == r));

  // Arrange the colors in the palette according to how distinct they are from
  // one another.
  arma::mat subdat = dm(r, r);

  // Start by finding the two most distant points in our subset
  arma::uvec sorted = arma::ind2sub(size(subdat), subdat.index_max());

  // Now pick colors from the matrix in order of their color difference
  // to the previously picked colors
  arma::uvec sub_range = arma::linspace<arma::uvec>(0, n - 1, n);

  while (sorted.n_elem < n) {
    arma::uvec excl = std_setdiff(sub_range, sorted);
    arma::rowvec mincols = arma::min(subdat.submat(sorted, excl), 0);
    arma::uvec::fixed<1> newrow;
    newrow.fill(excl(mincols.index_max()));
    sorted.insert_rows(sorted.n_elem, newrow);
  }

  return r(sorted) + 1;
}
