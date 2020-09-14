# ArtlasCatalogues

---

# Workflow to encode exhibition catalogues

The aim of the Artl@s project is to study the global circulation of images from the 1890s to the advent of the Internet. It manages several research projects on artistic and cultural globalization. It also takes an active interest in digital methodologies and in the circulation of images. 

One of its projects is BasArt, an online database of exhibition catalogs from the 19th and 20th centuries. To expand the database, Béatrice Joyeux-Prunel decided to find a way to process and structure the scanned exhibition catalogs in order to easily complete the database. They decided to use a pivot XML-TEI format and GROBID-dictionaries, a machine-learning software designed to automatically structure the lexicographical resources and to automatically encode the exhibition catalogs.

This repository includes all the steps to automatically encode an exhibition catalogue for the Artl@s project. 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/Schema-workflow.png" width="85%"></p>

## Prerequisites

**1.** Download this repository. Run in your terminal this command :
```
git clone https://github.com/carolinecorbieres/ArtlasCatalogues.git
```

**2.** For the steps 1 and 2 you will need to have python 3 installed. Run in your terminal this command : 
```
python -m pip install SomePackage
```

- If you want to work in a virtual environnment, you have to create one : 
  - Install the virtualenv PyPI library.

  ```
  pip3 install virtualenv
  ```

  - Move to the project directory.

  ```
  cd YOUR_PATH_TO_THE_PROJECT/ArtlasCatalogues
  ```

  - Set up your Python virtual environment.
  ```
  virtualenv -p python3 env
  ```

  - Activate the environment.

  ```
  source env/bin/activate
  ```

- Install libraries and dependencies :

```
pip3 install -r requirements.txt
```

## Contribute

You can contribute to the project by encoding new catalogues and/or creating new models for GROBID-dictionaries. If you do so, please update this repository with your new data.

## Thanks

Thanks to Simon Gabay, Matthias Gille Levenson, Ljudmila Petkovic, Auriane Quoix, Jean-Paul Rehr, Lucie Rondeau du Noyer and Barbara Topalov for their help and work. 

## Credits

This repository is developed by Caroline Corbières with the help of Simon Gabay, under the supervision of Béatrice Joyeux-Prunel, as part of the project [Artl@s](https://artlas.huma-num.fr/fr/).

## Licence

This repository is CC-BY.

<a rel="license" href="https://creativecommons.org/licenses/by/2.0"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/2.0/88x31.png" /></a><br/>

## Cite this repository

Caroline Corbières, Simon Gabay and Béatrice Joyeux-Prunel, _Worklow to encode exhibition catalogues_, 2020, https://github.com/carolinecorbieres/ArtlasCatalogues.
