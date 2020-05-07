import { IList, ListAction, ListContext, ListItem, Neovim } from 'coc.nvim';
import Manager from '../manager';
export default class Branches implements IList {
    private manager;
    readonly name = "branches";
    readonly description = "git branches";
    readonly defaultAction = "checkout";
    actions: ListAction[];
    constructor(nvim: Neovim, manager: Manager);
    loadItems(context: ListContext): Promise<ListItem[]>;
}
