clear all
close all
clc
addpath tools
load GT

filename = 'groundtruth.txt';
trajRead
trajEst
trajGenerate


IMUgenerate2
trajShow
trajWrite