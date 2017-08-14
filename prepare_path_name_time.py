"""
prepare pathway name and pathway time for pathway-probability evaluation
"""
import os
import numpy as np


def prepare_pathway_name(file_dir, top_n=5, flag="", delimiter=","):
    """
    prepare pathway_name.csv
    """
    # read from pathway_stat.csv
    f_n_ps = os.path.join(file_dir, "output", "pathway_stat.csv")
    if flag == "":
        f_n_pn = os.path.join(file_dir, "input", "pathway_name.csv")
    else:
        f_n_pn = os.path.join(file_dir, "input",
                              "pathway_name_" + str(flag) + ".csv")

    try:
        os.remove(f_n_pn)
    except OSError:
        pass

    # read
    data = np.genfromtxt(f_n_ps, dtype=str, delimiter=delimiter)
    path_list = [val[0] for idx, val in enumerate(data) if idx < top_n]

    # save
    np.savetxt(f_n_pn, path_list, fmt="%s")


def prepare_pathway_time(file_dir, top_n=5, num=1, flag=""):
    """
    prepare pathway_time.csv
    num represents number of points
    """
    if flag == "":
        f_n_pt = os.path.join(file_dir, "input", "pathway_time.csv")
    else:
        f_n_pt = os.path.join(file_dir, "input",
                              "pathway_time_" + str(flag) + ".csv")

    try:
        os.remove(f_n_pt)
    except OSError:
        pass

    # time matrix
    t_mat = np.empty((top_n, num + 1, ))
    for idx, _ in enumerate(t_mat):
        t_mat[idx] = np.linspace(0.0, 1.0, num + 1)

    np.savetxt(f_n_pt, t_mat[:, 1::], delimiter=',', fmt='%.7f')


# if __name__ == '__main__':
#     print("hello")
#     FILE_DIR = os.path.abspath(os.path.join(os.path.realpath(
#         sys.argv[0]), os.pardir, os.pardir, os.pardir))
#     print(FILE_DIR)

#     prepare_pathway_name(FILE_DIR)
#     prepare_pathway_time(FILE_DIR, top_n=50, num=1)