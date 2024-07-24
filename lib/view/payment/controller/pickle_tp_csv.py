import pickle

datasetPath = "/Users/hicham/Documents/flutter_projects/giveagift/lib/view/payment/controller/datasets.p"

outputPath = "/Users/hicham/Documents/flutter_projects/giveagift/lib/view/payment/controller/datasets.csv"

def read():
    ''' Read the dataset from the pickle. '''
    with open(datasetPath, 'rb') as f:
        return pickle.load(f)

def pkl2csv():
    ''' Convert the pickle to a CSV. '''
    dataset = read()

    with open(outputPath, 'w') as f:
        for pos in dataset.keys():
            for i, (l, r) in enumerate(dataset[pos]):
                f.write(f'{pos},{i},{l},{r}\n')

if __name__ == "__main__":
    pkl2csv()