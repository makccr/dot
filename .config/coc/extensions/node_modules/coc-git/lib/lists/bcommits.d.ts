import { BasicList, ListAction, ListContext, ListTask, Neovim } from 'coc.nvim';
import Manager from '../manager';
export default class Bcommits extends BasicList {
    private manager;
    readonly name = "bcommits";
    readonly description = "Commits of current file.";
    readonly defaultAction = "show";
    actions: ListAction[];
    private bufnr;
    constructor(nvim: Neovim, manager: Manager);
    loadItems(context: ListContext): Promise<ListTask>;
}
