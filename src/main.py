import pygame
from pygame.locals import *

# Initialize Pygame
pygame.init()

screen = pygame.display.set_mode((400, 600))
pygame.display.set_caption('Tetris')

# Game loop
running = True

while running:
    for event in pygame.event.get():
        if event.type == QUIT:
            running = False

pygame.quit()
