# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import (absolute_import, division, print_function)

# You can import any python module as needed.
import os
import subprocess
import shlex

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command
from ranger.core.loader import CommandLoader

class fzf_select(Command):
    """
    :fzf_select
    Busca archivos recursivamente con fd/find y fzf, con vista previa.
    """
    def execute(self):
        # Obtenemos la ruta del directorio actual
        directory = self.fm.thisdir.path

        # Comprobamos si fd está disponible (más rápido)
        try:
            subprocess.run(['fd', '--version'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
            find_cmd = f"fd --type f --hidden . {shlex.quote(directory)}"
        except (subprocess.CalledProcessError, FileNotFoundError):
            # Si no está fd, usamos find
            find_cmd = f"find {shlex.quote(directory)} -type f"

        # Construimos el comando fzf con previsualización usando bat (para texto)
        # Si el archivo no es texto, bat mostrará un mensaje, pero podemos mejorarlo
        fzf_cmd = (
            f"{find_cmd} | fzf --preview 'bat --color=always --style=numbers --line-range=:500 {{}} 2>/dev/null || "
            "file --brief {{}}'"
        )

        # Ejecutamos fzf de forma interactiva
        fzf_process = subprocess.Popen(fzf_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
        stdout, _ = fzf_process.communicate()

        if fzf_process.returncode == 0 and stdout.strip():
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)
