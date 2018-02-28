# the accuracy seems to converge at 50% using dnn

import numpy as np
import tensorflow as tf
import sklearn.model_selection as sk


def add_layer(inputs, in_size, out_size, activation_function=None):
  # add one more layer and return the output of this layer
  Weights = tf.Variable(tf.random_normal([in_size, out_size]))

  biases = tf.Variable(tf.random_normal([1, out_size]))
  #biases = tf.Variable(tf.zeros([1, out_size]) + 0.1)
  Wx_plus_b = tf.matmul(inputs, Weights) + biases
  if activation_function is None:
    outputs = Wx_plus_b
  else:
    outputs = activation_function(Wx_plus_b)
    return outputs


def get_accuracy(test_xs, test_ys):
  global prediction
  y_pre = sess.run(prediction, feed_dict = {xs: test_xs})
  correct_prediction = tf.equal(tf.argmax(y_pre, 1), tf.argmax(test_ys, 1))
  accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
  result = sess.run(accuracy, feed_dict = {xs: test_xs, ys: test_ys})
  return result


# load the data
features = np.loadtxt('features.csv', delimiter = ',')
labels = np.loadtxt('onehotLabels.csv', delimiter = ',')

# spliting into train and test cases
train_x, test_x, train_y, test_y = sk.train_test_split(features, labels, test_size = 0.3)



# define placeholder for inputs to network
xs = tf.placeholder(tf.float32, [None, 2])
ys = tf.placeholder(tf.float32, [None, 9])


# add hidden layer
h1 = add_layer(xs, 2, 18, activation_function= tf.nn.relu)
# add output layer
prediction = add_layer(h1, 18, 9, activation_function = tf.nn.softmax)


# the error between prediction and real data
loss = tf.reduce_mean(-tf.reduce_sum(ys * tf.log(prediction), reduction_indices = [1]))
#loss = tf.reduce_mean(tf.reduce_sum(tf.square(ys - prediction), reduction_indices=[1]))


train_step = tf.train.GradientDescentOptimizer(0.1).minimize(loss)

# initialization
init = tf.global_variables_initializer()

# run session
sess = tf.Session()
sess.run(init)


# number of epoch
for i in range(50000):
  # training
  sess.run(train_step, feed_dict={xs: train_x, ys: train_y})
  if i % 100 == 0:
    # to see the step improvement
    """
    print(sess.run(loss, feed_dict={xs: train_x, ys: train_y}))
    """
    print('%d epoch accuracy: %f' % (i, get_accuracy(test_x, test_y)))


