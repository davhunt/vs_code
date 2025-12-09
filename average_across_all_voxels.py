import os
import sys
import nibabel as nib
import statistics

def avg_value(img, mask):
    data = nib.load(img).get_fdata()
    mask = nib.load(mask).get_fdata()
    x,y,z = data.shape
    sum = 0; n = 0
    for i in range(0,x):
        for j in range(0,y):
            for k in range(0,z):
                if mask[i,j,k] == 1:
                    sum += data[i,j,k]
                    n += 1
    return float(sum / n)


if __name__ == "__main__":
    img = sys.argv[1]
    mask = sys.argv[2]

    return avg_value(img, mask)